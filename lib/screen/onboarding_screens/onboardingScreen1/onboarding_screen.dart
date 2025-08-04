

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../screen/onboarding_screens/onboardingScreen1/widgets/landscape_intro_widget.dart';
import '../../../screen/onboarding_screens/onboardingScreen1/widgets/landscape_title_desc_buttons.dart';
import '../../../screen/onboarding_screens/onboardingScreen1/widgets/portrait_design.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';

import '../../../model/main_app_json.dart';
import '../../../utils/constant.dart';
import '../../../utils/listes.dart';
import '../default_dot_indicator.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key, required this.onboardingData});
  final List<OnboardingScreenSectionComponent>? onboardingData;

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final PageController pageController =
      PageController(); // التحكم في التمرير بين الصفحات
  final PageController horizontalPageController =
      PageController(); // التحكم في التمرير الأفقي في الوضع الأفقي
  int activePage = 0; // الصفحة النشطة حالياً

  List<Color> backgroundColors = const [
    // ألوان الخلفية لكل صفحة
    Color(0xff88CCFC),
    Color(0xffFFBEF1),
    Color(0xffFFDDAA),
  ];

  final List<String> images =
      onboarding2Images(); // استدعاء الصور المستخدمة في الشاشات

  void onNextPage() {
    // دالة للانتقال إلى الصفحة التالية
    if (activePage < widget.onboardingData!.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 200), // مدة الانتقال
        curve: Curves.fastEaseInToSlowEaseOut, // منحنى الانتقال
      );
      if (MediaQuery.of(context).orientation != Orientation.portrait) {
        horizontalPageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastEaseInToSlowEaseOut,
        );
      }
    } else {
      GlobalCubit.get(context)
          .onBoardingGetStartedPressed(); // إذا كانت الصفحة الأخيرة، تنفيذ دالة "ابدأ"
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation ==
        Orientation.portrait; // التحقق إذا كانت الشاشة عمودية

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              // عند تغيير الصفحة
              if (isPortrait) {
                setState(() {
                  activePage = index; // تحديث الصفحة النشطة
                });
              }
            },
            physics: isPortrait
                ? null
                : const NeverScrollableScrollPhysics(), // تعطيل التمرير في الوضع الأفقي
            controller: pageController,
            itemCount: widget.onboardingData!.length,
            itemBuilder: (context, index) {
              final onboardingItem = widget.onboardingData![index];
              return Container(
                color: backgroundColors[index], // تعيين لون الخلفية للصفحة
                child: isPortrait
                    ? PortraitDesign(
                        isLastPage: activePage ==
                            widget.onboardingData!.length -
                                1, // إذا كانت الصفحة الأخيرة
                        title: onboardingItem.title,
                        description: onboardingItem.body,
                        image: images[index],
                        onTab: onNextPage,
                      )
                    : LandscapeIntroWidget(image: images[activePage]),
              );
            },
          ),
          PositionedDirectional(
            top: isPortrait
                ? MediaQuery.of(context).size.height / 2
                : MediaQuery.of(context).size.height / 1.1,
            start: 0,
            end: isPortrait ? 0 : MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.onboardingData!.length,
                (index) => DefDotIndicator(
                  isCurrentIndex: activePage == index,
                  activeHeight: 4.0,
                  inactiveHeight: 4.0,
                  marginRight: 11,
                  activeWidth: 8.9,
                  inactiveWidth: 8.9,
                ),
              ),
            ),
          ),
          if (!isPortrait)
            LandscapeTitleAndDescAndButtons(
              activePage: activePage,
              onboardingData: widget.onboardingData!,
              onNextPage: onNextPage,
              onPageChanged: (index) {
                setState(() {
                  activePage = index;
                });
              },
              horizontalPageController: horizontalPageController,
            ),
          if (isPortrait)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: activePage == widget.onboardingData!.length - 1
                    ? GestureDetector(
                        onTap: onNextPage,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 104.w(context)),
                          height: 54.h(context),
                          width: 186.w(context),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              getLocalizedText(context).translate('lbl_get_start')??'',
                              style: TextStyle(
                                color: primaryColor.isDark() ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w(context),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              GlobalCubit.get(context)
                                  .onBoardingGetStartedPressed();
                            },
                            child: Text(
                              getLocalizedText(context).translate('lbl_skip')??'',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w(context),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onNextPage,
                            child: Container(
                              height: 78.h(context),
                              width: 78.w(context),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward, // أيقونة السهم للتقدم
                                color:
                                primaryColor.isDark() ? Colors.white : Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
