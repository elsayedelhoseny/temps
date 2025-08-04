import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/responsive.dart';

class DefDotIndicator extends StatelessWidget {
  final bool isCurrentIndex;
  final double activeHeight;
  final double inactiveHeight;
  final double activeWidth;
  final double inactiveWidth;
  final double marginRight;
  final double marginTop;
  final double marginLeft;
  final double marginBottom;

  const DefDotIndicator({
    super.key,
    required this.isCurrentIndex,
    this.activeHeight = 6.0,
    this.inactiveHeight = 4.0,
    this.activeWidth = 31.0,
    this.inactiveWidth = 6.0,
    this.marginRight = 0.0,
    this.marginTop = 0.0,
    this.marginLeft = 0.0,
    this.marginBottom = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
      height:
          isCurrentIndex ? activeHeight.h(context) : inactiveHeight.h(context),
      width: isCurrentIndex ? activeWidth.w(context) : inactiveWidth.w(context),
      margin: EdgeInsets.only(
        right: marginRight.w(context),
        bottom: marginBottom.w(context),
        left: marginLeft.w(context),
        top: marginTop.w(context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isCurrentIndex ? primaryColor : primaryColor.withOpacity(0.4),
      ),
    );
  }
}
