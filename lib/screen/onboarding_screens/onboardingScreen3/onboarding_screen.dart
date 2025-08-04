
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../screen/onboarding_screens/onboardingScreen3/widgets/bottom_button.dart';
import '../../../screen/onboarding_screens/onboardingScreen3/widgets/onboarding_page.dart';
import '../../../screen/onboarding_screens/onboardingScreen3/widgets/skip_button.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../../utils/listes.dart';
import '../default_dot_indicator.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key, required this.onboardingData});
  final List<OnboardingScreenSectionComponent>? onboardingData;

  @override
  OnboardingScreen3State createState() => OnboardingScreen3State();
}

class OnboardingScreen3State extends State<OnboardingScreen3> {
  int currentIndex = 0;
  late PageController controller;
  final List<String> images = onboarding3Images();

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                SizedBox(height: 56.h(context)),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: widget.onboardingData!.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, index) => OnboardingPage3(
                    onboardingData: widget.onboardingData![index],
                    images: images[index],
                    isPortrait: MediaQuery.of(context).orientation ==
                        Orientation.portrait,
                  ),
                ),
              ),
            ],
          ),
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.onboardingData!.length,
                  (index) => DefDotIndicator(
                    isCurrentIndex: currentIndex == index,
                    marginRight: 12,
                    marginTop: 18,
                    activeHeight: 8.0,
                    inactiveHeight: 8.0,
                    activeWidth: 8.0,
                    inactiveWidth: 8.0,

                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomButton(
              currentIndex: currentIndex,
              controller: controller,
              onLastPage: currentIndex == widget.onboardingData!.length - 1,
            ),
          ),
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Positioned(
              bottom: 95.h(context),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.onboardingData!.length,
                  (index) => DefDotIndicator(
                    isCurrentIndex: currentIndex == index,
                    activeHeight: 8.0,
                    inactiveHeight: 4.0,
                    activeWidth: 10.9,
                    inactiveWidth: 6.0,

                  ),
                ),
              ),
            ),
          if (currentIndex < widget.onboardingData!.length - 1)
            SkipButton(onSkip: () {
              GlobalCubit.get(context).onBoardingGetStartedPressed();
            }),
        ],
      ),
    );
  }
}
