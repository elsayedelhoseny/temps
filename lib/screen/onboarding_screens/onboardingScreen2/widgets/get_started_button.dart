

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../cubit/Global/cubit.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/responsive.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
          start: MediaQuery.of(context).orientation == Orientation.portrait
              ? 28.w(context)
              : 65.w(context),
          end: MediaQuery.of(context).orientation == Orientation.portrait
              ? 28.w(context)
              : 65.w(context),
          top: MediaQuery.of(context).orientation == Orientation.portrait
              ? 170.h(context)
              : 15.h(context),
          bottom: 46.h(context)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: primaryColor),
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? 61.h(context)
          : 50.h(context),
      child: TextButton(
          onPressed: () async {
            GlobalCubit.get(context).onBoardingGetStartedPressed();
          },
          child: Text(
            getLocalizedText(context).translate('lbl_get_start')??'',
            style: TextStyle(
                color: primaryColor.isDark() ? Colors.white : Colors.black,
                fontSize: 17.w(context),
                fontWeight: FontWeight.w700),
          )),
    );
  }
}
