
import 'package:flutter/material.dart';
import '../../../cubit/Global/cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/responsive.dart';
import '../../../model/main_app_json.dart';
import '../../AppWidget.dart';

class BottomNavStyle4 extends StatefulWidget {
  final List<NavBarItem> items;
  final int selectedIndex;
  final PageController webPagesController;
  const BottomNavStyle4({
    super.key,
  required this.webPagesController,
    required this.items,
    required this.selectedIndex,
  });

  @override
  BottomNavStyle4State createState() => BottomNavStyle4State();
}

class BottomNavStyle4State extends State<BottomNavStyle4>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // تهيئة الـ AnimationController مع مدة الأنيميشن
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // تهيئة الـ Animation باستخدام Tween وCurvedAnimation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // تشغيل الأنيميشن عند بدء التطبيق
    _scaleController.forward();
  }

  @override
  void didUpdateWidget(covariant BottomNavStyle4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      // إعادة تشغيل الأنيميشن عند تغيير selectedIndex
      _scaleController.reset();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    // التخلص من الـ AnimationController لتجنب تسريبات الذاكرة
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    double itemWidth = MediaQuery.of(context).size.width / widget.items.length;
    double centerXOffset = itemWidth / 2 - 30.w(context);
    double calculatedLeftPosition = isRTL
        ? MediaQuery.of(context).size.width -
            (widget.selectedIndex + 1) * itemWidth +
            centerXOffset
        : widget.selectedIndex * itemWidth + centerXOffset;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.items.map((item) {
            int index = widget.items.indexOf(item);
            bool isSelected = widget.selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {

                  GlobalCubit.get(context).changeBottomNavIndex(index: index, webPagesController: widget.webPagesController);

                },
                child: Container(
                  color: primaryColor,
                  height: 70.h(context),

                  child: Center(
                    child: Visibility(
                      visible: !isSelected,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          cachedImage(
                            item.iconImage,
                            width: 24.w(context),
                            height: 24.h(context),
                            color: iconColor.withValues(alpha: 0.6),
                          ),
                          FittedBox(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: iconColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.w(context),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.selectedIndex != -1)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            top: -30.h(context),
            left: calculatedLeftPosition,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: (){
                  GlobalCubit.get(context).changeBottomNavIndex(index: widget.selectedIndex, webPagesController: widget.webPagesController);
                },
                child: Container(
                  width: 65.w(context),
                  height: 80.h(context),
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor,
                      boxShadow:
                      [

                          BoxShadow(
                            color: iconColor.withValues(alpha: 0.5),
                            offset: Offset(0, 1),
                            blurStyle: BlurStyle.outer,
                            blurRadius: 20,
                          ),
                      ],
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w(context),
                      height: 60.h(context),
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Center(
                        child: cachedImage(
                          widget.items[widget.selectedIndex].iconImage!,
                          color: iconColor,
                          width: 24.w(context),
                          height: 24.h(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

