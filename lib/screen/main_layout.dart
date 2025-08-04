import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/expiration_checker.dart';
import '../component/otp_reviewer_toast.dart';
import '../cubit/Global/cubit.dart';
import '../cubit/Global/states.dart';
import '../screen/HomeScreen.dart';
import '../screen/privacy_policy_screen.dart';
import '../screen/splash.dart';
import '../utils/bottom_nav_bar/bottom_nav_manager.dart';
import '../utils/constant.dart';
import 'NotificationWebScreen.dart';
import 'onboarding_screens/onboarding_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayoutScreen extends StatefulWidget {
  MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late PageController webPagesController;

  @override
  void initState() {
    super.initState();
    webPagesController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notificationUrl != null) {
        push(NotificationWebScreen(
          mInitialUrl: notificationUrl,
        ));
      }
    });
  }

  @override
  void dispose() {
    webPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ExpirationChecker(
        child: Stack(
          children: [
            Scaffold(
                body: HomeScreen(
                  webPagesController: webPagesController,
                ),
                bottomNavigationBar: BlocBuilder<GlobalCubit, GlobalStates>(
                    builder: (context, state) {
                    return BottomNavManager(
                      styleName:
                          // 'style5',
                          mainAppJson != null
                              ? mainAppJson!.settings.navBarSection.templateStyle
                              : 'style1',
                      selectedIndex: GlobalCubit.get(context).bottomNavIndex,
                      webPagesController: webPagesController,
                    );
                  }
                )),
            if (mainAppJson != null)
              if (!endOnboarding!)
                OnboardingManager(
                  templateName: mainAppJson!
                      .settings.onboardingScreenSection.templateStyle,
                  onboardingData: GlobalCubit.get(context).onboardingData,
                ),
            if (mainAppJson != null &&
                GlobalCubit.get(context).privacyHtml != null)
              if (!endPrivacyPolicy!)
                PrivacyPolicyScreen(
                  htmlcontent: GlobalCubit.get(context).privacyHtml!,
                ),
            if (GlobalCubit.get(context).showSplash) SplashScreen(),
            OTPToast(),
          ],
        ),
      ),
    );
  }
}
