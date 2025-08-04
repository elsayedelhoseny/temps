
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';

class BottomNavStyle2 extends StatefulWidget {
  final List<NavBarItem> items;
  final int selectedIndex;
  final PageController webPagesController;
  const BottomNavStyle2({
    required this.items,
    required this.selectedIndex,
  required this.webPagesController,
    super.key,
  });
  @override
  BottomNavStyle2State createState() => BottomNavStyle2State();
}

class BottomNavStyle2State extends State<BottomNavStyle2>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<Offset>> _animationList;
  int _lastSelectedIndex = 0;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _initializeAnimations(length: 5);
    _selectedIndex = widget.selectedIndex;
    Future.delayed(Duration(seconds: 4),(){
      _initializeAnimations(length: widget.items.length);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationControllerList[_selectedIndex].forward();
      });
    });
  }

  void _initializeAnimations({required int length}) {
    _animationControllerList = List.generate(length, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    _animationList = List.generate(length, (index) {
      return _buildAnimation(_animationControllerList[index]);
    });
  }
  Animation<Offset> _buildAnimation(AnimationController controller) {
    return Tween(
      begin: const Offset(0, 60),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(controller);
  }


  Widget buildItem(NavBarItem item, bool isSelected, int itemIndex) {
    return AnimatedBuilder(
      animation: _animationList[itemIndex],
      builder: (context, child) => Container(
        width: 100.w(context),
        height: 80.h(context),
        margin: EdgeInsetsDirectional.only(bottom: 10.h(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: cachedImage(
                height: 30.h(context),
                width: 30.w(context),
                item.iconImage,
                color: isSelected
                    ? iconColor
                    : iconColor.withValues(alpha: 0.6),
              ),
            ),
            Transform.translate(
              offset: _animationList[itemIndex].value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 5.h(context),
                width: 5.w(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: isSelected
                      ? iconColor
                      : iconColor.withValues(alpha: 0.6),
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
  Widget build(BuildContext context) {
    if (widget.items.length != _animationControllerList.length) {
      _initializeAnimations(length: widget.items.length );
    }

    if (widget.selectedIndex != _selectedIndex) {
      setState(() {
        _lastSelectedIndex = _selectedIndex;
        _selectedIndex = widget.selectedIndex;
        _animationControllerList[_selectedIndex].forward();
        _animationControllerList[_lastSelectedIndex].reverse();
      });
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80.h(context),
      padding: EdgeInsetsDirectional.only(bottom: 10.h(context)),
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.items.map((item) {
          final int index = widget.items.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {

                GlobalCubit.get(context).changeBottomNavIndex(index: index, webPagesController: widget.webPagesController);

              },
              child: buildItem(item, _selectedIndex == index, index),
            ),
          );
        }).toList(),
      ),
    );
  }
}
