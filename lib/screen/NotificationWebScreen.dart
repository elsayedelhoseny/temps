import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/expiration_checker.dart';
import '../cubit/Global/cubit.dart';
import '../screen/main_layout.dart';
import '../utils/colors.dart';
import 'HomeScreen.dart';

// ignore: must_be_immutable
class NotificationWebScreen extends StatefulWidget {
  static String tag = '/WebScreen';

  String? mInitialUrl;

  NotificationWebScreen({
    this.mInitialUrl,
  });

  @override
  NotificationWebScreenState createState() => NotificationWebScreenState();
}

class NotificationWebScreenState extends State<NotificationWebScreen> {
  bool isWasConnectionLoss = false;
  bool mIsPermissionGrant = false;

  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: iconColor,
        backgroundColor: primaryColor,
      ),
      onRefresh: () async {
        GlobalCubit.get(context).onRefresh(
            fromNotification: true,
            notificationPullToRefreshControllers: pullToRefreshController);
      },
    );
    setStatusBarColor(
      primaryColor,
      statusBarBrightness: Platform.isIOS
          ? (primaryColor.isDark() ? Brightness.dark : Brightness.light)
          : Brightness.light,
      statusBarIconBrightness: Platform.isIOS
          ? (primaryColor.isDark() ? Brightness.dark : Brightness.light)
          : null,
    );
    super.initState();
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          mIsPermissionGrant = true;
          setState(() {});
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _exitApp() async {
    if (await GlobalCubit.get(context)
        .notificationWebViewController!
        .canGoBack()) {
      GlobalCubit.get(context).notificationWebViewController!.goBack();
    } else {
      GlobalCubit.get(context).exitNotification().then((v) {
        push(MainLayoutScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, r) => _exitApp(),
      child: ExpirationChecker(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(color: primaryColor),
            ),
            leading: IconButton(
              onPressed: () {
                _exitApp();
              },
              icon: Icon(
                Icons.arrow_back,
                color: iconColor,
              ),
            ),
          ),
          body: LoadWeb(
            mURL: widget.mInitialUrl ?? '',
            options: GlobalCubit.get(context).options,
            pullToRefreshController: pullToRefreshController!,
            fromNotification: true,
          ),
        ),
      ),
    );
  }
}
