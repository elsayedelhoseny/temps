import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/draggable_widget.dart';
import '../cubit/Global/cubit.dart';
import '../cubit/Global/states.dart';
import '../utils/AppWidget.dart';
import '../utils/back_button.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/loader.dart';
import '../utils/responsive.dart';

class LoadWeb extends StatefulWidget {
  final String mURL;
  final PullToRefreshController pullToRefreshController;
  final InAppWebViewSettings? options;
  final bool fromNotification;

  const LoadWeb({
    Key? key,
    required this.mURL,
    required this.pullToRefreshController,
    required this.options,
    this.fromNotification = false,
  }) : super(key: key);

  @override
  _LoadWebState createState() => _LoadWebState();
}

class _LoadWebState extends State<LoadWeb> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalStates>(
        builder: (context, state) {
        return Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.mURL)),
              pullToRefreshController: widget.pullToRefreshController,
              initialSettings: widget.options,
              onWebViewCreated: (controller) async {
                //to ensure that controller have been created after webview created
                GlobalCubit.get(context).setLoading(showLoading: true, fromNotification: widget.fromNotification);
                await Future.delayed(Duration(seconds: 2));
                //then updated saved one
                GlobalCubit.get(context).updateController(controller,fromNotification: widget.fromNotification);
              },
              onContentSizeChanged: (controller, oldSize, newSize) =>
                  GlobalCubit.get(context).handleContentSizeChange(controller,fromNotification: widget.fromNotification),
              onZoomScaleChanged: (controller, oldScale, newScale) =>
                  GlobalCubit.get(context).handleZoomChange(controller,fromNotification: widget.fromNotification),
              onLoadStart: (controller, url) async => await GlobalCubit.get(context)
                  .handleLoadStart(controller, url, context,fromNotification: widget.fromNotification),
              onTitleChanged: (controller, title) =>
                  GlobalCubit.get(context).handleTitleChanged(controller, title),
              onConsoleMessage: (controller, message) => GlobalCubit.get(context)
                  .onConsoleMessage(message: message, context: context),
              onProgressChanged: (controller, progress) => GlobalCubit.get(context)
                  .handleProgressChange(context,
                      progress: progress, controller: controller),
              onLoadStop: (controller, url) =>
                  GlobalCubit.get(context).handleLoadStop(controller, url, context),
              onReceivedError: (controller, request, error) =>
                  GlobalCubit.get(context).handleError(controller, request, error),
              shouldOverrideUrlLoading: (controller, navigationAction) =>
                  GlobalCubit.get(context)
                      .handleUrlOverride(controller, navigationAction),
              onDownloadStartRequest:
                  GlobalCubit.get(context).handleDownloadRequest,
              onGeolocationPermissionsShowPrompt:
                  GlobalCubit.get(context).handleGeolocationPrompt,
              onPermissionRequest: GlobalCubit.get(context).handlePermissionRequest,
            ),
            if (GlobalCubit.get(context).enableBackBtn && !widget.fromNotification)
              PositionedDirectional(
                start: GlobalCubit.get(context)
                    .backButtonRightPadding
                    .toDouble()
                    .w(context),
                top: GlobalCubit.get(context)
                    .backButtonTopPadding
                    .toDouble()
                    .h(context),
                child: DefaultBackButton(
                  onPressed: () {
                    GlobalCubit.get(context).goBack();
                  },
                  icon: Icons.arrow_back,
                ),
              ),
            if (GlobalCubit.get(context).loadingList[GlobalCubit.get(context).bottomNavIndex] || GlobalCubit.get(context).notificationWebLoading)
              Container(
                color: primaryColor,
                height: context.height(),
                width: context.width(),
                child: Loaders().center(),
              ),
          ],
        );
      }
    );
  }
}

class KeepPageAlive extends StatefulWidget {
  final Widget child;

  const KeepPageAlive({
    required this.child,
  });

  @override
  _KeepPageAliveState createState() => _KeepPageAliveState();
}

class _KeepPageAliveState extends State<KeepPageAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure the state is preserved
    return widget.child;
  }
}

class HomeScreen extends StatefulWidget {
  static const String tag = '/HomeScreen';
  final String? mUrl;
  final String? title;
  final PageController webPagesController;
  const HomeScreen({this.mUrl, this.title, required this.webPagesController});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool mIsPermissionGrant = false;

  @override
  void initState() {
    // GlobalCubit.get(context).controller = PageController();
    // checkPermission();
    super.initState();
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          setState(() => mIsPermissionGrant = true);
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, r) =>
          GlobalCubit.get(context).exitAppDialog(context),
      child: Scaffold(
        backgroundColor: context.cardColor,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: primaryColor,
                    child: SafeArea(
                      child: PageView(
                        controller: widget.webPagesController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                            GlobalCubit.get(context).navigationBarTaps.length,
                            (index) {
                          return KeepPageAlive(
                            child: LoadWeb(
                              key: ValueKey("webview_${GlobalCubit.get(context).navigationBarTaps[index].url}"),
                              mURL: GlobalCubit.get(context)
                                  .navigationBarTaps[index]
                                  .url,
                              pullToRefreshController: GlobalCubit.get(context)
                                      .pullToRefreshControllers[
                                  index]!, // Use the index here
                              options: GlobalCubit.get(context).options,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (GlobalCubit.get(context).enableWhatsapp)
              Visibility(
                visible: GlobalCubit.get(context).isWhatsappIconDynamic,
                child: DraggableCustomWidget(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(top: 200.h(context)),
                    child: DefaultBackButton(
                      isOutsideHome: true,
                      height: 80.h(context),
                      centerWidget: Container(
                        child: cachedImage(
                          mainAppJson != null
                              ? GlobalCubit.get(context)
                                  .selectedWhatsappIcon
                                  .icon
                              : "",
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            "https://wa.me/${GlobalCubit.get(context).whatsappNum}"));
                      },
                    ),
                  ),
                ),
                replacement: PositionedDirectional(
                  start: GlobalCubit.get(context)
                      .whatsappRightPadding
                      .toDouble()
                      .w(context),
                  bottom: GlobalCubit.get(context)
                      .whatsappBottomPadding
                      .toDouble()
                      .h(context),
                  child: DefaultBackButton(
                    isOutsideHome: true,
                    height: 80.h(context),
                    centerWidget: cachedImage(
                      mainAppJson != null
                          ? GlobalCubit.get(context).selectedWhatsappIcon.icon
                          : "",
                      fit: BoxFit.contain,
                    ),
                    onPressed: () async {
                      await launchUrl(Uri.parse(
                          "https://wa.me/${GlobalCubit.get(context).whatsappNum}"));
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
