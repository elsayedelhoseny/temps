
import 'package:flutter/material.dart';
import '../../../screen/onboarding_screens/onboardingScreen2/widgets/get_started_button.dart';
import '../../../screen/onboarding_screens/onboardingScreen2/widgets/nav_buttons.dart';
import '../../../screen/onboarding_screens/onboardingScreen2/widgets/onboarding_page.dart';
import '../../../model/main_app_json.dart';
import '../../../utils/listes.dart';
import '../default_dot_indicator.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key, required this.onboardingData});
  final List<OnboardingScreenSectionComponent>? onboardingData;

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  final PageController pageController = PageController();
  bool isLastPage = false;
  int currentIndex = 0;
  final List<String> images = onboarding1Images();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) => setState(() {
                isLastPage = widget.onboardingData!.length - 1 == index;
                currentIndex = index;
              }),
              itemCount: widget.onboardingData!.length,
              controller: pageController,
              itemBuilder: (context, index) {
                final isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                return OnboardingPage1(
                  onboardingData: widget.onboardingData![index],
                  images: images[index],
                  isPortrait: isPortrait,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.onboardingData!.length,
              (index) => DefDotIndicator(
                isCurrentIndex: currentIndex == index,
                activeHeight: 6.0,
                inactiveHeight: 6.0,
                activeWidth: 32.0,
                marginRight: 11,
                inactiveWidth: 6.0,
              ),
            ),
          ),

          if (isLastPage)
            const GetStartedButton()
          else
            NavigationButtons(
              isLastPage: isLastPage,
              pageController: pageController,
            ),
        ],
      ),
    );
  }
}
