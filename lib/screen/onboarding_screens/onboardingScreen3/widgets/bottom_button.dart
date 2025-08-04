
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../cubit/Global/cubit.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/responsive.dart';
import '../../../../utils/constant.dart';

class BottomButton extends StatelessWidget {
  final int currentIndex;
  final PageController controller;
  final bool onLastPage;

  const BottomButton({
    required this.currentIndex,
    required this.controller,
    required this.onLastPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h(context),
      margin: EdgeInsetsDirectional.only(
        bottom: MediaQuery.of(context).orientation == Orientation.portrait
            ? 150.h(context)
            : 20,
        start: 28.w(context),
        end: 28.w(context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        child: FittedBox(
          child: Text(
            onLastPage
                ? getLocalizedText(context).translate('lbl_get_continue')??''
                : getLocalizedText(context).translate('lbl_next')??'',
            style: TextStyle(
              color: primaryColor.isDark() ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        onPressed: () {
          if (onLastPage) {
            GlobalCubit.get(context).onBoardingGetStartedPressed();
          } else {
            controller.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}
