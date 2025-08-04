
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';

class BottomNavStyle5 extends StatelessWidget {
  const BottomNavStyle5({
    required this.items,
    required this.selectedIndex,
    required this.webPagesController,
    super.key,
  });
  final PageController webPagesController;
  final List<NavBarItem> items;
  final int selectedIndex;

  Widget _buildIcon(
      NavBarItem item, bool isSelected, BuildContext context) {
    return cachedImage(
      item.iconImage,
      // height: 25.h(context),
      // width: 25.h(context),
      color: isSelected ? iconColor : iconColor.withValues(alpha: 0.6),
    );
  }

  Widget _buildTitle(
      NavBarItem item, bool isSelected, BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: isSelected ? iconColor : iconColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(item.title!),
        ),
      ),
    );
  }

  Widget buildItem(
      NavBarItem item, bool isSelected, BuildContext context) {
    return AnimatedContainer(
      width: 100.w(context),
      height: 60.0.h(context),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
          boxShadow: [
            if(isSelected)
              BoxShadow(
                color: iconColor.withValues(alpha: 0.2),
                offset: Offset(0, -1),
                blurStyle: BlurStyle.inner,
                blurRadius: 50,


              ),
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: isSelected ? 2: 1,
              child: _buildIcon(item, isSelected, context)),
          Expanded(child: _buildTitle(item, isSelected, context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / items.length;
    return Container(
      width: double.infinity,
      height: 83.0.h(context),

      padding:  EdgeInsetsDirectional.zero,
      decoration: BoxDecoration(
          color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.4),
            offset: Offset(1, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 20,
          ),
        ]
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 15.h(context),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: Alignment.center,
                    width: selectedIndex == 0 ? 0 : itemWidth * selectedIndex,
                    height: 4.h(context),
                  ),
                  Flexible(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: itemWidth,
                      height: 4.h(context),
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w(context),),

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: iconColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 7.h(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: items.map((item) {
                      int index = items.indexOf(item);
                      return Flexible(
                        child: GestureDetector(
                          onTap: () {

                              GlobalCubit.get(context)
                                  .changeBottomNavIndex(index: index, webPagesController: webPagesController);

                          },
                          child: buildItem(item, selectedIndex == index, context),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
