//With PHP backend
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app_localizations.dart';
import '../config_file.dart';
import '../model/main_app_json.dart';
import '../screen/NotificationWebScreen.dart';
import 'cacheHelper/cache_helper.dart';

String? notificationUrl;
String? errorResponse;
bool? endOnboarding;
bool? endPrivacyPolicy;
String? modelHashValue;
MainAppJson? mainAppJson;
String? cachedData;
double? whatsappIconOffsetX;
double? whatsappIconOffsetY;
late DateTime currentDate;
late DateTime expirationDate;

AppLocalizations getLocalizedText(context) {
  return AppLocalizations.of(context)!;
}

bool isArab(BuildContext context) {
  return getLocalizedText(context).locale.languageCode == "ar";
}

Future<void> getCacheData() async {
  endOnboarding = await CacheHelper.getData(key: "endOnboarding") ?? false;
  endPrivacyPolicy =
      await CacheHelper.getData(key: "endprivacyPolicy") ?? false;
  modelHashValue = await CacheHelper.getData(key: "modelHashValue") ?? "0";
  cachedData = await CacheHelper.getData(key: 'mainAppJson');
  whatsappIconOffsetX =
      await CacheHelper.getData(key: 'whatsappIconOffsetX') ?? 10;
  whatsappIconOffsetY =
      await CacheHelper.getData(key: 'whatsappIconOffsetY') ?? 50;
}

void initialOneSignal() {
  OneSignal.initialize(oneSignalApiKey);
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(false);
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
    notificationUrl = event.notification.additionalData?["url"];
    event.preventDefault();
    event.notification.display();
  });
  OneSignal.Notifications.addClickListener((event) {
    print(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.additionalData}');
    notificationUrl = event.notification.additionalData?["url"];
    print(notificationUrl);
    if (notificationUrl != null) {
      // Navigate to a screen with the WebView
      push(NotificationWebScreen(
        mInitialUrl: notificationUrl,
      ));
    }
  });
}
