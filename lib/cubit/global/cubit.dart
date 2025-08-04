import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';
import '../../component/NoInternetConnection.dart';
import '../../config_file.dart';
import '../../model/main_app_json.dart';
import '../../screen/ErrorScreen.dart';
import '../../screen/main_layout.dart';
import '../../utils/AppWidget.dart';
import '../../utils/cacheHelper/cache_helper.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../utils/hex_to_color.dart';
import '../../utils/images.dart';
import '../Global/states.dart';
import '../otp_cubit/cubit.dart';
import '../../main.dart';

class GlobalCubit extends Cubit<GlobalStates> {
  GlobalCubit() : super(GlobalCubitInitial());

  static GlobalCubit get(context) => BlocProvider.of(context);

  bool? isReadForFirstTime;
  bool? isBlocked;
  bool showSplash = true;
  String popUpCode = "";
  List<OnboardingScreenSectionComponent> onboardingData = [];
  List<NavBarItem> navigationBarTaps = [];
  late List<InAppWebViewController?> webViewControllerList;
  late List<bool> loadingList;
  late List<PullToRefreshController?> pullToRefreshControllers = [];
  bool notificationWebLoading = false;
  int webPageNumber = 0;

  Future<void> setLoading(
      {required bool showLoading, fromNotification = false}) async {
    if (showLoading) {
      if (fromNotification) {
        notificationWebLoading = showLoading;
      } else {
        loadingList[bottomNavIndex] = showLoading;
      }
    } else {
      loadingList[bottomNavIndex] = showLoading;
      notificationWebLoading = showLoading;
    }
    emit(WebLoadingState());
  }

  InAppWebViewSettings options = InAppWebViewSettings(
    transparentBackground: true,
    allowFileAccess: true,
    disableDefaultErrorPage: true,
    allowUniversalAccessFromFileURLs: true,
    disableContextMenu: true,
    disableLongPressContextMenuOnLinks: true,
    useShouldOverrideUrlLoading: Platform.isAndroid ? true : false,
    userAgent: Platform.isAndroid
        ? "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Trujena/1.0 Mobile Safari/537.36"
        : "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Trujena/1.0 Mobile/15E148 Safari/604.1",
    mediaPlaybackRequiresUserGesture: true,
    allowFileAccessFromFileURLs: true,
    useOnDownloadStart: true,
    javaScriptCanOpenWindowsAutomatically: true,
    javaScriptEnabled: true,
    domStorageEnabled: true,
    supportZoom: false,
    incognito: false,
    useHybridComposition: true,
    allowContentAccess: false,
    allowsLinkPreview: false,
    isInspectable: true,
    allowsBackForwardNavigationGestures: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  Future<void> exitAppDialog(context) async {
    if (await webViewControllerList[bottomNavIndex]!.canGoBack()) {
      webViewControllerList[bottomNavIndex]!.goBack();
    } else {
      mConfirmationDialog(() {
        Navigator.of(context).pop(false);
      }, context, AppLocalizations.of(context));
    }
  }

  void _initializeWebViewControllers() {
    webViewControllerList =
        List.generate(navigationBarTaps.length, (_) => null);
    loadingList = List.generate(navigationBarTaps.length, (_) => false);
    if (pullToRefreshControllers.length < navigationBarTaps.length) {
      // Add new controllers for the additional items.
      int diff = navigationBarTaps.length - pullToRefreshControllers.length;
      for (int i = 0; i < diff; i++) {
        pullToRefreshControllers.add(
          PullToRefreshController(
            settings: PullToRefreshSettings(
              color: iconColor,
              backgroundColor: primaryColor,
            ),
            onRefresh: () async {
              onRefresh();
            },
          ),
        );
      }
    } else if (pullToRefreshControllers.length > navigationBarTaps.length) {
      // If the list is now shorter, truncate the list.
      pullToRefreshControllers =
          pullToRefreshControllers.sublist(0, navigationBarTaps.length);
    }
  }

  Future<void> exitNotification() async {
    notificationUrl = null;
    showSplash = false;
    emit(ExitNotificationState());
  }

  /// Initialize app - Using local data only (no remote calls)
  void init() async {
    expirationDate = currentDate.add(Duration(days: 1));
    emit(LoadingInitialState());
    splashState();

    try {
      // Get local data values from the local JSON
      final localJson = MainAppJson.fromJson(dashboardLocalAppMainJson);

      // Extract isBlocked and expirationDate from local data if available
      // You can set these values in your local JSON file
      isBlocked = false; // Set this based on your local data requirements
      // expirationDate is already set above, modify as needed

      // Check blocking and expiration using local values
      if (currentDate.isAfter(expirationDate) || isBlocked!) {
        emit(TimeOutState(isTimeOut: true));
      } else {
        isReadForFirstTime = getBoolAsync('isReadForFirstTime');
        emit(GetReadForFirstTimeValueState());

        bottomNavIndex = 0;
        emit(LoadingInitState());

        // Always use local model (no remote checking)
        await useLocalModel();
        emit(InitialWebViewControllersState());
      }
    } catch (e) {
      print('error ========from init======>$e');
      await useLocalModel();
    }
  }

  /// Use local model only - keeping all local data structure
  Future<void> useLocalModel() async {
    emit(tryingSavedModelState());

    // Try cache first, then fallback to local
    if (cachedData != null) {
      mainAppJson = MainAppJson.fromJson(jsonDecode(cachedData!));
      emit(SuccessUsingSavedModelState());
    } else {
      // Load from local fallback data
      mainAppJson = MainAppJson.fromJson(dashboardLocalAppMainJson);
      emit(UsingLocalModelState());
    }

    // Apply the model after loading from cache or fallback
    await applyModel(model: mainAppJson!);
    emit(SuccessAppliedSavedModelState());
  }

  String decodeBase64String(String base64String) {
    try {
      // Step 1: Sanitize input
      String sanitizedBase64 =
          base64String.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');

      // Step 2: Normalize URL-safe Base64
      sanitizedBase64 =
          sanitizedBase64.replaceAll('-', '+').replaceAll('_', '/');

      // Step 3: Split into chunks and decode
      List<String> chunks = sanitizedBase64.split('=');
      String decodedResult = '';

      for (var chunk in chunks) {
        if (chunk.isNotEmpty) {
          // Add padding to each chunk
          chunk = chunk.padRight((chunk.length + 3) ~/ 4 * 4, '=');
          decodedResult += utf8.decode(base64.decode(chunk));
        }
      }

      return decodedResult;
    } catch (e) {
      return "Error decoding Base64 string: $e";
    }
  }

  late List whatsappIcons;
  late WhatsAppIcon selectedWhatsappIcon;
  bool enableWhatsapp = false;
  bool enableBackBtn = false;
  bool isWhatsappIconDynamic = false;
  String whatsappNum = "";
  int whatsappRightPadding = 10;
  int whatsappBottomPadding = 50;
  int backButtonRightPadding = 4;
  int backButtonTopPadding = 102;
  String? privacyHtml;

  Future<void> applyModel({required MainAppJson model}) async {
    emit(AppliedModelState());
    try {
      onboardingData = model.settings.onboardingScreenSection.components;
      navigationBarTaps = model.settings.navBarSection.components[0].items;
      primaryColor = hexToColor(
          model.settings.appColorsSection.components[0].primaryColor);
      hexPrimaryColor =
          model.settings.appColorsSection.components[0].primaryColor;
      iconColor =
          hexToColor(model.settings.appColorsSection.components[0].iconsColor);
      _initializeWebViewControllers();
      elementsToHide =
          model.settings.developersSettingsSection.components[0].classes;
      enableBackBtn = model.settings.backButtonSection.components[0].enabled;
      backButtonRightPadding =
          model.settings.backButtonSection.components[0].rightPosition;
      backButtonTopPadding =
          model.settings.backButtonSection.components[0].topPosition;

      if (model.settings.whatsAppSection.components.isNotEmpty) {
        whatsappNum = model.settings.whatsAppSection.components[0].number;
        whatsappIcons = model.settings.whatsAppSection.components[0].icons;
        selectedWhatsappIcon = whatsappIcons.firstWhere(
          (icon) => icon.selected == true,
        );

        enableWhatsapp = model.settings.whatsAppSection.components[0].enabled;
        isWhatsappIconDynamic =
            model.settings.whatsAppSection.components[0].is_dynamic;
        whatsappRightPadding =
            model.settings.whatsAppSection.components[0].rightPosition;
        whatsappBottomPadding =
            model.settings.whatsAppSection.components[0].bottomPosition;
      } else {
        enableWhatsapp = false;
      }

      if (model.settings.privacyPolicySection.components.isNotEmpty) {
        privacyHtml =
            model.settings.privacyPolicySection.components[0].privacyPolicy;
      } else {
        privacyHtml = null;
      }

      setStatusBarColor(
        mainAppJson != null
            ? hexToColor(mainAppJson!
                .settings.splashScreenSection.components[0].backgroundColor)
            : primaryColor,
        statusBarBrightness: Platform.isIOS
            ? (hexToColor(mainAppJson!.settings.splashScreenSection
                        .components[0].backgroundColor)
                    .isDark()
                ? Brightness.dark
                : Brightness.light)
            : hexToColor(mainAppJson!.settings.splashScreenSection.components[0]
                        .backgroundColor)
                    .isDark()
                ? Brightness.light
                : Brightness.dark,
      );
      emit(AppliedModelState());
      print(elementsToHide);
      popUpCode = decodeBase64String(model.popups);
      emit(AppliedPopUpCodeState());
    } catch (e) {
      print(e);
      emit(ErrorApplyingModelState());
    }
  }

  Future<void> evaluatePopUpJs(
      InAppWebViewController controller, String currentUrl) async {
    emit(PopUpInitial());
    print("currentUrlcurrentUrl === $currentUrl");
    try {
      emit(PopUpJsEvaluating());
      if (currentUrl.contains("?")) {
        currentUrl = currentUrl.splitBefore("?");
        emit(PopUpJsUrlSet());
      } else {
        emit(PopUpJsUrlSet());
      }
      // Replace placeholders dynamically in the JavaScript code
      String PopUpCode = popUpCode.replaceAll("currentUrl", currentUrl);

      await controller.evaluateJavascript(
        source: PopUpCode,
      );

      emit(SuccessPopUpJsEvaluated());
    } catch (error) {
      print(error);
      emit(WebViewJsEvaluationError(error.toString()));
    }
  }

  void splashState() {
    showSplash = true;
    emit(SplashState());
    Future.delayed(const Duration(seconds: 5), () {
      showSplash = false;
      emit(EndSplashState());
      setStatusBarColor(
        primaryColor,
        statusBarBrightness: Platform.isIOS
            ? (primaryColor.isDark() ? Brightness.dark : Brightness.light)
            : Brightness.light,
        statusBarIconBrightness: Platform.isIOS
            ? (primaryColor.isDark() ? Brightness.dark : Brightness.light)
            : null,
      );
    });
  }

  void onBoardingGetStartedPressed() {
    endOnboarding = true;
    emit(OnboardingEndState());
    CacheHelper.saveData(key: 'endOnboarding', value: true);
  }

  void privacyPolicyGetStartedPressed() {
    endPrivacyPolicy = true;
    emit(PrivacyPolicyEndState());
    CacheHelper.saveData(key: 'endprivacyPolicy', value: true);
  }

  int bottomNavIndex = 0;

  Future<bool> checkCanGoBack() async {
    if (await webViewControllerList[bottomNavIndex]!.canGoBack()) {
      return true;
    } else
      return false;
  }

  Future<void> changeBottomNavIndex({
    required int index,
    required PageController webPagesController,
  }) async {
    if (bottomNavIndex == index) {
      if (webViewControllerList[bottomNavIndex] != null) {
        if (await checkCanGoBack()) {
          goBack();
          emit(ChangeCurrentIndexState());
        } else {
          print('not null');
          emit(ChangeCurrentIndexState());
        }
      } else {
        print(
            "<<<<<<<<<>>>>>>>>>>>>this controller is null<<<<<<<<<<<<<<>>>>>>>>>>>>>");
      }
    } else {
      print('ccccccccccccccccccccc${webViewControllerList[bottomNavIndex]}');
      bottomNavIndex = index;
      webPagesController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.linearToEaseOut);
      emit(ChangeCurrentIndexState());
    }
  }

  void goToErrorScreen() {
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => ErrorScreen(
        error: getLocalizedText(context).translate('lbl_try_again'),
        errorImage: ic_about,
      ),
    ));
  }

  void goToNoInternetScreen() {
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => NoInternetConnection(),
    ));
  }

  void alreadyRead() {
    isReadForFirstTime = true;
    setValue('isReadForFirstTime', true);
    emit(ReadForFirstTimeState());
  }

  void goBack() async {
    if (await webViewControllerList[bottomNavIndex]!.canGoBack()) {
      webViewControllerList[bottomNavIndex]!.goBack();
      emit(GoBackState());
    }
  }

  bool _isRefreshing = false;

  Future<void> onRefresh({
    fromNotification = false,
    PullToRefreshController? notificationPullToRefreshControllers,
  }) async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      await Future.delayed(Duration(seconds: 1));
      setLoading(
          showLoading: _isRefreshing, fromNotification: fromNotification);
      if (Platform.isAndroid) {
        if (fromNotification) {
          notificationWebViewController!.reload();
        } else {
          webViewControllerList[bottomNavIndex]!.reload();
        }
      } else if (Platform.isIOS) {
        if (fromNotification) {
          notificationWebViewController!.loadUrl(
              urlRequest: URLRequest(
                  url: await notificationWebViewController!.getUrl()));
        } else {
          webViewControllerList[bottomNavIndex]!.loadUrl(
              urlRequest: URLRequest(
                  url: await webViewControllerList[bottomNavIndex]!.getUrl()));
        }
      }
    } finally {
      await Future.delayed(Duration(seconds: 1));
      _isRefreshing = false;
      if (fromNotification) {
        notificationPullToRefreshControllers!.endRefreshing();
      } else {
        pullToRefreshControllers[bottomNavIndex]!.endRefreshing();
      }
    }
  }

  bool userLoggedInRefresh = false;
  bool isUserLoggedIn = false;
  bool userDetectionOnStarting = true;

  void detectUserLogin(BuildContext context,
      {required InAppWebViewController controller}) {
    if (userDetectionOnStarting) {
      //do nothing while the app starting
    } else {
      // JavaScript code to detect login
      String jsCode = """
 (function() {
    // Use a global flag to avoid duplicate creation
    if (window.myObserverInitialized) return;

    const targetNode = document.body;
    const config = { childList: true, subtree: true };

    const callback = function(mutationsList, observer) {
        for (let mutation of mutationsList) {
            if (mutation.type === 'childList') {
                const loggedInElement = document.querySelector('.s-user-menu-trigger'); // Salla login element selector
                if (loggedInElement) {
                    // Call Flutter method when user logs in
                    window.flutter_inappwebview.callHandler('onUserLoggedIn');
                    observer.disconnect(); // Disconnect observer once the login is detected
                    break;
                }
            }
        }
    };

    // Initialize observer if not already initialized
    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);

    // Set a global flag to indicate observer initialization
    window.myObserverInitialized = true;
})();
  """;

      // Evaluate the JavaScript in the WebView
      controller.evaluateJavascript(source: jsCode);

      // Add JavaScript handler for login detection
      controller.addJavaScriptHandler(
        handlerName: "onUserLoggedIn",
        callback: (args) async {
          if (!isUserLoggedIn) {
            isUserLoggedIn = true;
            userLoggedInRefresh = true;
            bottomNavIndex = 0;
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute<void>(
              builder: (BuildContext context) => MainLayoutScreen(),
            ));
            emit(UserLoginState());
            await Future.delayed(Duration(seconds: 1));
            emit(UserLoginRefreshState());
          }
        },
      );
    }
  }

/////////////////////////////// WebView Logic ///////////////////////////////
  InAppWebViewController? notificationWebViewController;
  void updateController(InAppWebViewController controller,
      {fromNotification = false}) {
    if (fromNotification) {
      notificationWebViewController = controller;
    } else {
      webViewControllerList[bottomNavIndex] = controller;
    }
    emit(WebViewControllerUpdatedState());
  }

  void handleContentSizeChange(InAppWebViewController controller,
      {fromNotification = false}) {
    updateController(controller, fromNotification: fromNotification);
  }

  void handleZoomChange(InAppWebViewController controller,
      {fromNotification = false}) {
    updateController(controller, fromNotification: fromNotification);
  }

  void onConsoleMessage({required message, required context}) {
    if (message.message.contains("Twilight config passed from parent 🤩")) {
      userDetectionOnStarting = false;
      if (state is! UserLoginState) {
        emit(UserLoginState());
      }
      if (Platform.isAndroid &&
          currentDate.isBefore(reviewerDateEnd) &&
          !GlobalCubit.get(context).isUserLoggedIn) {
        OTPCubit.get(context).initiateOTPRequest();
      }
    }
  }

  Future<void> handleLoadStart(
      InAppWebViewController controller, Uri? url, context,
      {fromNotification = false}) async {
    updateController(controller, fromNotification: fromNotification);
    if (Platform.isAndroid) {
      OTPCubit.get(context).dismissToast();
    } else if (await handleExternalLinks(url.toString())) {
      if (await canLaunchUrl(
        url!,
      )) if (url.toString().startsWith('https://tr.snapchat.com') ||
          url.toString().startsWith('https://tr6.snapchat.com') ||
          url.toString().contains('https://tr6.snapchat.com') ||
          url.toString() == 'https://tr6.snapchat.com' ||
          url.toString().contains('https://tr.snapchat.com') ||
          url.toString() == 'https://tr.snapchat.com') return;
    }

    emit(WebViewLoadStartStateState());
    log("onLoadStart");

    // Check for 404 page
    if (await checkFor404(controller)) {
      return;
    }

    // Handle caching using custom logic
    bool isInCache = await _checkIfUrlIsCached(controller, url);
    if (isInCache) {
      print('inCache');
    } else {
      await setLoading(showLoading: true, fromNotification: fromNotification);
    }
  }

  final Set<String> _cachedUrls = {};

  Future<bool> _checkIfUrlIsCached(
      InAppWebViewController controller, Uri? url) async {
    if (url == null) return false;

    // Normalize the URL for comparison
    final normalizedUrl = _normalizeUrl(url.toString());

    // Check if the URL exists in the cache
    if (_cachedUrls.contains(normalizedUrl)) {
      return true;
    } else {
      // Add the URL to the cache
      _cachedUrls.add(normalizedUrl);
      return false;
    }
  }

  String _normalizeUrl(String url) {
    // Normalize the URL by removing trailing slashes and query parameters
    return url.replaceAll(RegExp(r'/$'), '').split('?')[0];
  }

  void handleTitleChanged(InAppWebViewController controller, String? title) {
    if (title != null) {
      if (title.contains('TO MANY REQUEST') ||
          title.contains('Error') ||
          title.contains('404')) {
        goToErrorScreen();
      }
    }
  }

  void handleProgressChange(context,
      {required int progress, required InAppWebViewController controller}) {
    if (progress > 70) {
      setLoading(showLoading: false);
    }
    // Emit progress only at thresholds
    if (progress % 25 == 0 || progress == 100) {
      emit(WebViewProgressChanged(progress));
    }
    detectUserLogin(context, controller: controller);
  }

  List<String> elementsToHide = [];

  Future<void> handleLoadStop(InAppWebViewController controller, WebUri? url,
      BuildContext context) async {
    log("onLoadStop");
    // Check for 404 page
    if (await checkFor404(controller)) {
      return;
    }

    // Ensure URL ends with a slash for evaluation consistency
    final formattedUrl =
        url.toString().endsWith('/') ? url.toString() : "${url.toString()}/";
    await evaluatePopUpJs(controller, formattedUrl);

    // Disable user selection
    await _evaluateJsSafely(
        controller, "document.body.style.webkitUserSelect='none';");

    for (String selector in elementsToHide) {
      if (selector.contains('footer')) {
        await _evaluateJsSafely(controller, """
    var footer = document.querySelector('footer');
    if (footer) footer.parentNode.removeChild(footer);
  """);
      } else {
        await _evaluateJsSafely(controller, """
       var element = document.querySelector("$selector");
        if (element) {
          element.style.display = 'none';
          console.log("✅ Hidden: " + "$selector");
        } else {
          console.log("❌ Not found: " + "$selector");
        }
    """);
      }
    }

    emit(WebViewLoadStopStateState());
  }

  Future<void> _evaluateJsSafely(
      InAppWebViewController controller, String script) async {
    try {
      await controller.evaluateJavascript(source: script);
    } catch (error) {
      debugPrint('Error executing JS: $error');
    }
  }

  Future<void> handleError(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error) async {
    setLoading(showLoading: false);
    log("onLoadError: ${error.description}z");

    // Handle specific errors
    if (error.description.contains('The request timed out') ||
        error.description.contains('net::ERR_TIMED_OUT') ||
        error.description.contains('net::ERR_NETWORK_CHANGED') ||
        error.description.contains('net::ERR_CONNECTION_CLOSED') ||
        error.description.contains('net::ERR_QUIC_PROTOCOL_ERROR') ||
        error.description.contains('net::ERR_ADDRESS_UNREACHABLE') ||
        error.description.contains('net::ERR_CONNECTION_REFUSED')) {
      goToErrorScreen();
    }
    String url = request.url.toString();
    log("Request URL: $url");
    if (url.toString().startsWith('https://tr.snapchat.com') ||
        url.toString().startsWith('https://tr6.snapchat.com') ||
        url.toString().contains('https://tr6.snapchat.com') ||
        url.toString() == 'https://tr6.snapchat.com' ||
        url.toString().contains('https://tr.snapchat.com') ||
        url.toString() == 'https://tr.snapchat.com') return;

    // Handle caching
    final isInCache = await controller.getCopyBackForwardList().then(
          (list) => list?.list?.any((entry) => entry.url == url),
        );

    if (isInCache == true) {
      InAppWebViewController.clearAllCache;
    } else {
      // Handle external links
      if (await handleExternalLinks(url)) {
        print('nooooooooooooo');
        await launchUrl(
          Uri.parse(url),
        );
        return;
      }
    }

    emit(WebViewErrorOccurred(error));
  }

  Future<NavigationActionPolicy> handleUrlOverride(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final url = navigationAction.request.url?.toString() ?? '';

    // Define Snapchat URL patterns
    final snapchatUrls = [
      'https://tr.snapchat.com',
      'https://tr6.snapchat.com',
    ];

    // Check if the URL matches any Snapchat patterns
    bool isSnapchatUrl = snapchatUrls.any((snapUrl) =>
        url.startsWith(snapUrl) || url.contains(snapUrl) || url == snapUrl);

    if (isSnapchatUrl) {
      return NavigationActionPolicy.CANCEL;
    }

    // Handle external URLs
    if (await handleExternalLinks(url)) {
      await launchUrl(Uri.parse(url));
      return NavigationActionPolicy.CANCEL;
    }

    // Log URL for debugging
    log("URL => $url");

    // Handle WhatsApp URLs
    final uri = Uri.parse(url);
    if (uri.scheme == 'whatsapp' ||
        url.startsWith('https://api.whatsapp.com') ||
        url.startsWith('whatsapp://')) {
      final phone = uri.queryParameters['phone'];
      if (phone != null) {
        final whatsappUrl = 'https://wa.me/$phone';
        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
          await launchUrl(Uri.parse(whatsappUrl));
          return NavigationActionPolicy.CANCEL;
        } else {
          log("Could not launch WhatsApp URL: $whatsappUrl");
        }
      }
      return NavigationActionPolicy.CANCEL;
    }

    // Allow the WebView to handle all other URLs
    return NavigationActionPolicy.ALLOW;
  }

  Future<void> handleDownloadRequest(InAppWebViewController controller,
      DownloadStartRequest downloadRequest) async {
    if (await Permission.storage.request().isGranted) {
      await launchUrl(Uri.parse(downloadRequest.url.toString()),
          mode: LaunchMode.inAppWebView);
    } else {
      log("Storage permission denied");
    }
  }

  Future<GeolocationPermissionShowPromptResponse> handleGeolocationPrompt(
      InAppWebViewController controller, String origin) async {
    if (await Permission.location.request().isGranted) {
      return GeolocationPermissionShowPromptResponse(
          origin: origin, allow: true, retain: true);
    } else {
      return GeolocationPermissionShowPromptResponse(
          origin: origin, allow: false, retain: false);
    }
  }

  Future<PermissionResponse> handlePermissionRequest(
      InAppWebViewController controller,
      PermissionRequest onPermissionRequest) async {
    for (var resource in onPermissionRequest.resources) {
      if (resource.toString().contains("AUDIO_CAPTURE")) {
        await Permission.microphone.request();
      } else if (resource.toString().contains("VIDEO_CAPTURE")) {
        await Permission.camera.request();
      }
    }
    return PermissionResponse(
        resources: onPermissionRequest.resources,
        action: PermissionResponseAction.GRANT);
  }

/////////////////////////////// Helper Methods ///////////////////////////////

  Future<bool> checkFor404(InAppWebViewController controller) async {
    String script = """
      if (document.querySelector('.main--404') !== null) {
          'Element exists';
      } else {
          'Element does not exist';
      }
    """;
    String? result = await controller.evaluateJavascript(source: script);
    return result == 'Element exists';
  }

  Future<bool> handleExternalLinks(String url) async {
    final externalLinks = [
      "linkedin.com",
      "market://",
      "whatsapp://",
      "truecaller://",
      "pinterest.com",
      "snapchat.com",
      "youtube.com",
      "instagram.com",
      "play.google.com",
      "mailto:",
      "tel:",
      "share=telegram",
      "messenger.com",
    ];

    if (externalLinks.any((link) => url.contains(link))) {
      return true;
    } else {
      return false;
    }
  }
}
