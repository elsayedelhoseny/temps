import 'package:flutter/material.dart';
import '../cubit/Global/cubit.dart';
import '../utils/AppWidget.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import '../app_localizations.dart';
import 'main_layout.dart';

class ErrorScreen extends StatefulWidget {
  static String tag = '/ErrorScreen';
  final String? error;
  final String? errorImage;
  final bool withoutColor;
  final double? height;
  ErrorScreen({this.error, this.errorImage, this.withoutColor = false, this.height});

  @override
  ErrorScreenState createState() => ErrorScreenState();
}

class ErrorScreenState extends State<ErrorScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (r,b) {
        mConfirmationDialog(() {
          Navigator.of(context).pop(false);
        }, context, AppLocalizations.of(context)!);
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cachedImage(
              widget.errorImage ?? ic_error,
              height: widget.height ?? 250,
              width: context.width(),
              color: widget.errorImage != null ?
              widget.withoutColor ? null : iconColor
                  : null,
            ),
            16.height,
            Text(widget.error.validate(),
                style: boldTextStyle(size: 20,color: iconColor), textAlign: TextAlign.center)
                .center()
                .paddingOnly(left: 16, right: 16),
            if(widget.errorImage != null && widget.errorImage != blockedError)
              Padding(
                padding: EdgeInsetsDirectional.all(MediaQuery.of(context).size.height / 20),
                child: MaterialButton(
                  onPressed: () {
                    GlobalCubit.get(context).bottomNavIndex = 0;
                    navigatorKey.currentState!.pushReplacement(MaterialPageRoute (
                      builder: (BuildContext context) => MainLayoutScreen(),
                    ));
                  },
                  child: Text(
                      AppLocalizations.of(context)!.translate('try_again')!,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  color: iconColor.withGreen(100),


                ),
              )
          ],
        ),
      ),
    );
  }
}
