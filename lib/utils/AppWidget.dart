import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../app_localizations.dart';
import '../main.dart';
import '../utils/constant.dart';
import '../utils/images.dart';
import 'package:nb_utils/nb_utils.dart';


Widget cachedImage(String? url, {double? height, Color? color, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(
      url!,
      height: height,
      color: color,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      errorBuilder: (context, object, stack){
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },

    ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Icon(Icons.error,color: iconColor,).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget setImage(String value) {
  return Image.asset(value, height: 18, width: 18, color: white).paddingAll(16);
}



bool mConfirmationDialog(Function onTap, BuildContext context, AppLocalizations? appLocalization) {
  showDialog(
    context: getContext,
    builder: (p0) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Row(
            children: [
              AppButton(
                elevation: 5,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius), side: BorderSide(color: viewLineColor)),
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, color: textPrimaryColorGlobal, size: 20),
                    6.width,
                    Text(
                      appLocalization!.translate('lbl_no')!,
                      style: boldTextStyle(color: textPrimaryColorGlobal),
                    ),
                  ],
                ).fit(),
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                elevation: 0,
                color: Colors.red,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 20),
                    6.width,
                    Text(
                      appLocalization!.translate('lbl_yes')!,
                      style: boldTextStyle(color: Colors.white),
                    ),
                  ],
                ).fit(),
                onTap: () {
                  exit(0);
                },
              ).expand(),
            ],
          ).paddingSymmetric(vertical: 8, horizontal: 16),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ic_cancel, fit: BoxFit.contain, height: 80, width: 80).paddingOnly(top: 16),
            20.height,
            Text(appLocalization.translate('lbl_logout')!, style: primaryTextStyle(size: 16), textAlign: TextAlign.center),
          ],
        ),
      );
    },
  );
  return true;
}
/// global Flutter error catcher and previewer
void globalDebuggingErrorCatcherForMainFile({required Function runApp})async{

  FlutterError.onError = (FlutterErrorDetails details) async{
    // Log the error (optional)
    debugPrint('Flutter error: ${details.exception}');
    // Show error popup
    showErrorDialog(details.exception.toString(), details.stack);
  };

  // Handle Flutter framework errors
  FlutterError.presentError = (FlutterErrorDetails details) async{
    debugPrint('FlutterError caught: ${details.exception}');
    showErrorDialog(details.exceptionAsString(), details.stack);
  };
  // Handle uncaught async errors
  runZonedGuarded(
        () async=> runApp(),
        (error, stackTrace) async{
      debugPrint('Async error caught: $error');
      showErrorDialog(error.toString(), stackTrace);
    },
  );
}
Widget debuggingErrorBuilder(context, child) {
  // Set a custom error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Log the error
    debugPrint('Widget error caught: ${details.exception}');
    // Show error dialog
    showErrorDialog(details.exceptionAsString(), details.stack);
    // Return an empty container instead of the red screen
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h(context),),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.fs(context)),
              child: Text(
                'Widget error caught: ${details.exception}',
                style: TextStyle(color: Colors.red, fontSize: 30),
              ),
            ),
            SizedBox(height: 16),
            if (details.stack != null) ...[
              Text(
                'Stack Trace:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(details.stack.toString()),
            ],
            TextButton(
              onPressed: () {
                // Reload the app
                runApp(MyApp());
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.restart_alt_sharp, color: Colors.green,size: 30,),
                  SizedBox(width: 10.w(context),),
                  Text('Reload'),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  };
  return child!;
}
void showErrorDialog(String errorMessage, StackTrace? stackTrace) {
  // Ensure dialog is shown from the current context
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false, // Prevent dismissing the dialog
        builder: (context) =>
            Directionality(
              textDirection: TextDirection.ltr,
              child: AlertDialog(
                title: Text('Error Occurred'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(errorMessage),
                      SizedBox(height: 16),
                      if (stackTrace != null) ...[
                        Text(
                          'Stack Trace:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(stackTrace.toString()),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Reload the app
                      runApp(MyApp());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.restart_alt_sharp, color: Colors.green,size: 30,),
                        SizedBox(width: 10.w(context),),
                        Text('Reload'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
      );
    }
  });
}
