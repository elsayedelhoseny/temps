
import 'package:flutter/material.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/responsive.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipButton({required this.onSkip, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).orientation == Orientation.landscape
          ? 30.h(context)
          : 50.h(context),
      right: 20.w(context),
      child: TextButton(
        onPressed: onSkip,
        child: Text(
          getLocalizedText(context).translate('lbl_skip')??'',
          style: TextStyle(
            fontSize: 20.54.w(context),
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
