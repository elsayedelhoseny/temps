import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubit/Global/cubit.dart';
import '../cubit/Global/states.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/AppWidget.dart';
import '../utils/hex_to_color.dart';

class SplashScreen extends StatefulWidget {
  final String? gradientColor1;
  final String? gradientColor2;
  final String? backgroundColor;
  final String? logoImage;
  final Widget? nextPage;

  const SplashScreen({
    super.key,
    this.gradientColor1,
    this.gradientColor2,
    this.backgroundColor,
    this.nextPage,
    this.logoImage,
  });

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isExpanded = false;
  late bool useGradient;

  @override
  void initState() {
    setStatusBarColor(
      mainAppJson != null
          ? hexToColor(mainAppJson!
              .settings.splashScreenSection.components[0].backgroundColor)
          : primaryColor,
      statusBarBrightness: Platform.isIOS
          ? (hexToColor(mainAppJson!.settings.splashScreenSection.components[0]
                      .backgroundColor)
                  .isDark()
              ? Brightness.dark
              : Brightness.light)
          : hexToColor(mainAppJson!.settings.splashScreenSection.components[0]
                      .backgroundColor)
                  .isDark()
              ? Brightness.light
              : Brightness.dark,
      // statusBarIconBrightness: Platform.isIOS
      //     ? (primaryColor.isDark()
      //     ? Brightness.dark
      //     : Brightness.light)
      //     : null,
    );
    useGradient =
        widget.gradientColor1 != null && widget.gradientColor2 != null;
    startAnimation();
    super.initState();
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isExpanded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalCubit, GlobalStates>(listener: (context, state) {
      if (state is! EndSplashState) {}
    }, builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          gradient: useGradient
              ? LinearGradient(
                  colors: [
                    hexToColor(widget.gradientColor1 ?? '#102933'),
                    hexToColor(widget.gradientColor2 ?? '#36535F'),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: useGradient
              ? null
              : mainAppJson != null
                  ? hexToColor(mainAppJson!.settings.splashScreenSection
                      .components[0].backgroundColor)
                  : primaryColor,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 4),
            width: isExpanded ? 200 : 50,
            height: isExpanded ? 200 : 50,
            child: cachedImage(mainAppJson != null
                ? mainAppJson!
                    .settings.splashScreenSection.components[0].logoImage
                : ""),
          ),
        ),
      );
    });
  }
}
