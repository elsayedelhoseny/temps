
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';

class BottomNavStyle3 extends StatefulWidget {
  const BottomNavStyle3({
    required this.items,
  required this.webPagesController,
    required this.selectedIndex,
    super.key,
  });
  final PageController webPagesController;
  final List<NavBarItem> items;
  final int selectedIndex;

  @override
  BottomNavStyle3State createState() => BottomNavStyle3State();
}

class BottomNavStyle3State extends State<BottomNavStyle3>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<double>> _animationList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
      _initializeAnimations(length: 5);
    Future.delayed(Duration(seconds: 4),(){
      _initializeAnimations(length: widget.items.length);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationControllerList[_selectedIndex].forward();
      });
    });
    // _animationControllerList = List.generate(
    //     widget.items.length,
    //     (i) => AnimationController(
    //         duration: const Duration(milliseconds: 300), vsync: this));
    //
    // _animationList = _animationControllerList
    //     .map((controller) => Tween(begin: 0.95, end: 1.18)
    //         .chain(CurveTween(curve: Curves.easeInOut))
    //         .animate(controller))
    //     .toList();

  }
  void _initializeAnimations({required int length}) {
    print("length is${widget.items.length}");
    _animationControllerList = List.generate(
      length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _animationList = _animationControllerList
        .map((controller) => Tween(begin: 0.95, end: 1.18)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller))
        .toList();
  }
  Widget buildItem(NavBarItem item, bool isSelected, int itemIndex) {
    return AnimatedBuilder(
            animation: _animationList[itemIndex],
            builder: (_, __) => Transform.scale(
              scale: _animationList[itemIndex].value,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w(context), vertical: 8.5.h(context)),
                alignment: Alignment.center,
                width: 150.w(context),
                height: 84.h(context),
                margin: EdgeInsetsDirectional.only(bottom: 10.h(context)),

                decoration: BoxDecoration(

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: cachedImage(
                        item.iconImage,
                        height: 24.h(context),
                        width: 24.w(context),
                        color: isSelected
                            ? iconColor
                            : iconColor.withValues(alpha: 0.6),
                      ),
                    ),
                    if (item.title.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h(context)),
                        child: FittedBox(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: isSelected
                                  ? iconColor
                                  : iconColor.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
    if (widget.selectedIndex != _selectedIndex) {
      _animationControllerList[_selectedIndex].reverse();
      _selectedIndex = widget.selectedIndex;
      _animationControllerList[_selectedIndex].forward();
    }

    return Container(
      width: double.infinity,
      height: 70.h(context),
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
        children: widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
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
