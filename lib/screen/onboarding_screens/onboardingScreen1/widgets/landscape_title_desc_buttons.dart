
import 'package:flutter/material.dart';
import '../../../../cubit/Global/cubit.dart';
import '../../../../model/main_app_json.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/responsive.dart';

class LandscapeTitleAndDescAndButtons extends StatelessWidget {
  final int activePage;
  final List<OnboardingScreenSectionComponent> onboardingData;
  final Function onNextPage;
  final PageController horizontalPageController;
  final void Function(int)? onPageChanged;
  const LandscapeTitleAndDescAndButtons({
    required this.activePage,
    required this.onboardingData,
    required this.onNextPage,
    required this.horizontalPageController,
    super.key,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(50),
                bottomStart: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: onPageChanged,
                    controller: horizontalPageController,
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FittedBox(
                            child: Text(
                              onboardingData[activePage].title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h(context)),
                          Text(
                            onboardingData[activePage].body,
                            style: TextStyle(
                              fontSize: 16.w(context),
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                activePage == 2
                    ? SizedBox(
                        height: 46.h(context),
                        child: MaterialButton(
                          color: const Color(0xffFF4975),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onPressed: () => onNextPage(),
                          child: Text(
                            getLocalizedText(context).translate('lbl_get_start')??'',
                            style: const TextStyle(color: Colors.white),
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
                            child: Text(getLocalizedText(context).translate('lbl_skip')??'',
                                style: const TextStyle(color: Colors.black)),
                          ),
                          GestureDetector(
                            onTap: () => onNextPage(),
                            child: Container(
                              height: 78.h(context),
                              width: 78.w(context),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xffFF4975)
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: const Color(0xffFF4975),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white, size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
