


import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../cubit/Global/cubit.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/responsive.dart';

class NavigationButtons extends StatelessWidget {
  final bool isLastPage;
  final PageController pageController;

  const NavigationButtons({
    super.key,
    required this.isLastPage,
    required this.pageController,

  });

  @override
  Widget build(BuildContext context) {
    return isLastPage
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsetsDirectional.only(
                start: 28.w(context),
                end: 28.w(context),
                top: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 170.h(context)
                    : 0,
                bottom: 46.h(context)),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        GlobalCubit.get(context).onBoardingGetStartedPressed();
                      },
                      child: Text(
                        getLocalizedText(context).translate('lbl_skip')??'',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontSize: 17.w(context)),
                      )),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor),
                    height:
                        MediaQuery.of(context).orientation == Orientation.portrait
                            ? 61.h(context)
                            : 50.h(context),
                    width:
                        MediaQuery.of(context).orientation == Orientation.portrait
                            ? 170.w(context)
                            : 150.w(context),
                    child: TextButton(
                        onPressed: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn),
                        child: Text(
                          getLocalizedText(context).translate('lbl_get_continue')??'',
                          style: TextStyle(
                              color: primaryColor.isDark() ? Colors.white : Colors.black,
                              fontSize: 17.w(context),
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ),
              ],
            ),
          );
  }
}
