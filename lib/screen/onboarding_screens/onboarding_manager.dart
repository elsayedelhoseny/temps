
import 'package:flutter/material.dart';
import '../../model/main_app_json.dart';
import 'onboardingScreen1/onboarding_screen.dart';
import 'onboardingScreen2/onboarding_screen.dart';
import 'onboardingScreen3/onboarding_screen.dart';

enum OnboardingScreenType { screen1, screen2, screen3 }

class OnboardingManager extends StatelessWidget {
  final List<OnboardingScreenSectionComponent>? onboardingData;

  final String templateName;

  const OnboardingManager({
    super.key,
    required this.onboardingData,
    required this.templateName,
  });

  OnboardingScreenType? getScreenType(String templateName) {
    switch (templateName) {
      case 'style1':
        return OnboardingScreenType.screen1;
      case 'style2':
        return OnboardingScreenType.screen2;
      case 'style3':
        return OnboardingScreenType.screen3;
      default:
        return OnboardingScreenType.screen1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(templateName);

    if (screenType == null) {
      return const Scaffold(
        body: Center(child: Text('Screen not found')),
      );
    }

    switch (screenType) {
      case OnboardingScreenType.screen1:
        return OnboardingScreen1(onboardingData: onboardingData);
      case OnboardingScreenType.screen2:
        return OnboardingScreen2(onboardingData: onboardingData);
      case OnboardingScreenType.screen3:
        return OnboardingScreen3(onboardingData: onboardingData);
      default:
        return const Scaffold(
          body: Center(child: Text('Screen not found')),
        );
    }
  }
}
