
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import 'nav_bar_styles/style_5_bottom_nav_bar.dart';
import 'nav_bar_styles/style_1_bottom_nav_bar.dart';
import 'nav_bar_styles/style_3_bottom_nav_bar.widget.dart';
import 'nav_bar_styles/style_4_bottom_nav_bar.widget.dart';
import 'nav_bar_styles/style_2_bottom_nav_bar.dart';

class BottomNavManager extends StatelessWidget {
  final String styleName;
  final int selectedIndex;

    final PageController webPagesController;
  const BottomNavManager({
    super.key,
    required this.styleName,
    required this.selectedIndex,
    required this.webPagesController,
  });

  Widget? getBottomNavStyle(String templateStyle, BuildContext context) {
    switch (templateStyle) {
      case 'style1':
        return BottomNavStyle1(
          items: GlobalCubit.get(context).navigationBarTaps,
          selectedIndex: selectedIndex,
          webPagesController: webPagesController,
        );
      case 'style2':
        return BottomNavStyle2(
          items: GlobalCubit.get(context).navigationBarTaps,
          selectedIndex: selectedIndex,
          webPagesController: webPagesController,
        );
      case 'style3':
        return BottomNavStyle3(
          items: GlobalCubit.get(context).navigationBarTaps,
          selectedIndex: selectedIndex,
          webPagesController: webPagesController,
        );
      case 'style4':
        return BottomNavStyle4(
          items: GlobalCubit.get(context).navigationBarTaps,
          selectedIndex: selectedIndex,
          webPagesController: webPagesController,
        );
      case 'style5':
        return BottomNavStyle5(
          items: GlobalCubit.get(context).navigationBarTaps,
          selectedIndex: selectedIndex,
          webPagesController: webPagesController,
        );
      // case 'style6':
      //   return BottomNavStyle6(
      //     items: GlobalCubit.get(context).navigationBarTaps,
      //     selectedIndex: selectedIndex,
      //   );
      default:
        return const Scaffold(
          body: Center(child: Text('Style not found')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBottomNavStyle(styleName, context) ??
        const Scaffold(
          body: Center(child: Text('Style not found')),
        );
  }
}
