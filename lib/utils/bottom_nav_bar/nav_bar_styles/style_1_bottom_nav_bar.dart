
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';

import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';


class BottomNavStyle1 extends StatelessWidget {
  final List<NavBarItem> items;
  final int selectedIndex;
  final PageController webPagesController;
  const BottomNavStyle1({
    required this.items,
    required this.selectedIndex,
  required this.webPagesController,
    super.key,
  });

  Widget buildItem(
    final NavBarItem item,
    final bool isSelected,
    BuildContext context,
  ) {
    return  AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: isSelected ? 120.w(context) : 50.w(context),
            height: 83.h(context),
            padding: const EdgeInsets.all(5),
      margin: EdgeInsetsDirectional.only(bottom: 10.h(context)),

            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? iconColor.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
                boxShadow:
                [
                  if(isSelected)
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    offset: Offset(0, 3),
                    blurStyle: BlurStyle.inner,
                    blurRadius: 20,
                  ),
                ]
            ),
            child: Container(
              alignment: Alignment.center,
              height: 83.h(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: cachedImage(
                      item.iconImage!,
                      // height: 24.h(context),
                      // width: 24.w(context),
                      color: isSelected
                          ? iconColor
                          : iconColor.withValues(alpha: 0.6),
                    ),
                  ),
                  if (isSelected)
                    Flexible(
                      // flex: 2,
                      child: FittedBox(
                        child: Text(
                          item.title??'',
                          style: TextStyle(
                            color: isSelected
                                ? iconColor
                                : iconColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w700,
                            // fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 70.0.h(context),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.4),
              offset: Offset(0, 0),
              blurStyle: BlurStyle.outer,
              blurRadius: 20,

            ),
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length,    (index)=> GestureDetector(
          onTap: () {
            GlobalCubit.get(context).changeBottomNavIndex(index: index, webPagesController: webPagesController);
          },
          child: Container(
            color: Colors.transparent,
            child:
            buildItem(items[index], selectedIndex == index, context),
          ),
        )
        )


      ),
    );
  }
}

