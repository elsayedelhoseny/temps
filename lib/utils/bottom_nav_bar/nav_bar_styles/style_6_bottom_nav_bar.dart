
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';

class BottomNavStyle6 extends StatefulWidget {
  const BottomNavStyle6({
    required this.items,
    required this.selectedIndex,
    required this.webPagesController,
    super.key,
  });

    final PageController webPagesController;
  final List<NavBarItem> items;
  final int selectedIndex;

  @override
  BottomNavStyle6State createState() => BottomNavStyle6State();
}

class BottomNavStyle6State extends State<BottomNavStyle6>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<double>> _animationList;

  int? _lastSelectedIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _lastSelectedIndex = _selectedIndex = 0;

    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationControllerList[_selectedIndex!].forward();
    });
  }

  void _initializeAnimations() {
    _animationControllerList = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _animationList = _animationControllerList
        .map((controller) => Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(controller))
        .toList();
  }

  Widget buildItem(final NavBarItem item, final bool isSelected,
      final int itemIndex) {
    if (item.iconImage.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationList[itemIndex],
      builder: (final context, final child) => SizedBox(
        width: 100.w(context),
        height: 83.h(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: isSelected ? 2:1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        // width: 35.w(context),
                        // height: 35.h(context),
                        decoration:  BoxDecoration(
                          color: iconColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  cachedImage(
                    item.iconImage,
                    // height: 24.h(context),
                    // width: 24.w(context),
                    color: isSelected ? iconColor : iconColor.withOpacity(0.6),
                  ),
                ],
              ),
            ),
            if (item.title.isNotEmpty)
              Container(
                padding: EdgeInsets.only(top: 3.h(context)),
                height: isSelected?
                25.h(context) : 30.h(context),
                child: FittedBox(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? iconColor : iconColor.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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
  void dispose() {
    for (var controller in _animationControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.items.length != _animationControllerList.length) {
      _initializeAnimations();
    }

    if (widget.selectedIndex != _selectedIndex) {
      _lastSelectedIndex = _selectedIndex;
      _selectedIndex = widget.selectedIndex;
      _animationControllerList[_selectedIndex!].forward();
      _animationControllerList[_lastSelectedIndex!].reverse();
    }

    return Container(
      padding: EdgeInsets.only(top: 3.h(context)),
      width: double.infinity,
      height: 65.h(context),
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.4),
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
            blurRadius: 20,
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.map((final item) {
          final int index = widget.items.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {

                  GlobalCubit.get(context).changeBottomNavIndex(index: index, webPagesController: widget.webPagesController);

              },
              child: Container(
                color: Colors.transparent,
                child: buildItem(item, widget.selectedIndex == index, index),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
