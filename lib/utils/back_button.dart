

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../cubit/Global/cubit.dart';





double screenWidth(
    BuildContext context, {
      double? portraitPercent,
      double? landscapePercent,
    }) {
  if (MediaQuery.of(context).orientation.name == "portrait" &&
      portraitPercent != null) {
    return (MediaQuery.of(context).size.width * portraitPercent) / 100;
  } else if (MediaQuery.of(context).orientation.name != "portrait" &&
      landscapePercent != null) {
    return (MediaQuery.of(context).size.width * landscapePercent) / 100;
  } else {
    return MediaQuery.of(context).size.width;
  }
}
double screenHeight(
    BuildContext context, {
      double? portraitPercent,
      double? landscapePercent,
    }) {
  if (MediaQuery.of(context).orientation.name == "portrait" &&
      portraitPercent != null) {
    return (MediaQuery.of(context).size.height * portraitPercent) / 100;
  } else if (MediaQuery.of(context).orientation.name != "portrait" &&
      landscapePercent != null) {
    return (MediaQuery.of(context).size.height * landscapePercent) / 100;
  } else {
    return MediaQuery.of(context).size.height;
  }
}


////////////////////////////////////controls of default small buttons //////////////////////////////

///on press function of small buttons
void Function()? onTapOfSmallButtons(setState, widget) =>
    widget.onPressed == null
        ? null
        : () {
      setState(() {
        isPressed = true;
        Future.delayed(
            const Duration(
              milliseconds: 50,
            ), () {
          setState(() {
            isPressed = false;
          });
        }).then((value) => widget.onPressed!());
      });
    };

/// function of onVerticalDragStar of small buttons to contact the screen and  begin to move vertically
void Function(DragStartDetails)? onVerticalDragStartOfSmallButtons(
    setState, widget) =>
    widget.onPressed == null
        ? null
        : (_) {
      setState(() {
        isPressed = true;
        Future.delayed(
            const Duration(
              milliseconds: 50,
            ), () {
          setState(() {
            isPressed = false;
          });
        }).then((value) => widget.onPressed!());
      });
    };
///////////////////////////////////////main AnimatedContainer of small buttons/////////////////////////
///duration of main AnimatedContainer of small buttons
const Duration durationOfMainAnimatedContainerOfSmallButtons =
Duration(milliseconds: 100);

///alignment of main AnimatedContainer of small buttons
const AlignmentGeometry alignmentOfMainAnimatedContainerOfSmallButtons =
    AlignmentDirectional.center;

///height of main AnimatedContainer of small buttons
double? heightOfMainAnimatedContainerOfSmallButtons(widget, context) =>
    widget.height ?? 40.h(context);

///width of main AnimatedContainer of small buttons
double? widthOfMainAnimatedContainerOfSmallButtons(widget, context) =>
    widget.width ?? 40.w(context);

///padding in main AnimatedContainer of small buttons
EdgeInsetsGeometry? paddingOfMainAnimatedContainerOfSmallButtons =
EdgeInsetsDirectional.all(2);

///clipBehavior  of main AnimatedContainer of small buttons
Clip clipBehaviorOfMainAnimatedContainerOfSmallButtons = Clip.antiAlias;

///decoration of main AnimatedContainer of small buttons
Decoration? decorationOfMainAnimatedContainerOfSmallButtons(widget) {
  return BoxDecoration(
    color: widget.centerWidget != null?
    Colors.transparent : null,
    gradient: widget.centerWidget == null? LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor,
        primaryColor.withValues(alpha: 0.5),
      ],
    ) : null,
    border: widget.centerWidget == null? Border.all(
      color:  primaryColor,
      width: 2,
      style: BorderStyle.solid,
    ): null,
    borderRadius: BorderRadius.circular(widget.radius),
    boxShadow: widget.centerWidget == null?
    isPressed
        ? []
        : [
      BoxShadow(
          offset: const Offset(0, 3),
          blurRadius: 2,
          color: primaryColor.withOpacity(0.4),
          spreadRadius: 1,
          blurStyle: BlurStyle.inner),
    ]: null,
  );
}
/////////////////////////////////button contented AnimatedContainer///////////////////////////
///duration of contented AnimatedContainer of small buttons
const Duration durationOfContentedAnimatedContainerOfSmallButtons =
Duration(milliseconds: 100);

///alignment of contented AnimatedContainer of small buttons
AlignmentGeometry? alignmentOfContentedAnimatedContainerOfSmallButtons =
    AlignmentDirectional.center;

///padding in contented AnimatedContainer of small buttons
EdgeInsetsGeometry? paddingOfContentedAnimatedContainerOfSmallButtons =
    EdgeInsetsDirectional.zero;

///clipBehavior  of contented AnimatedContainer of small buttons
Clip clipBehaviorOfOfContentedAnimatedContainerOfSmallButtons = Clip.antiAlias;

///decoration of contented AnimatedContainer of small buttons
Decoration? decorationOfContentedAnimatedContainerOfSmallButtons(widget) =>
    BoxDecoration(
      color: widget.centerWidget == null? primaryColor : null,
      borderRadius: BorderRadius.circular(widget.radius),
      boxShadow: widget.centerWidget == null?
      isPressed
          ? []
          : [
        BoxShadow(
            offset: const Offset(0, -3),
            blurRadius: 2,
            color: Colors.grey.shade500,
            spreadRadius: 1,
            blurStyle: BlurStyle.outer),
      ]: null,
    );

///fit stack of contented AnimatedContainer of small buttons
StackFit fitOfContentedAnimatedContainerOfSmallButtons = StackFit.loose;

///padding of stack of contented AnimatedContainer of small buttons
EdgeInsetsGeometry paddingOfStackOfContentedAnimatedContainerOfSmallButtons(
    context) =>
    EdgeInsetsDirectional.only(
        start: screenWidth(context, portraitPercent: 14),
        top: screenHeight(context, portraitPercent: 30));
//////////////////////////////icons of small buttons//////////////////////////////////////
///color of back icons of small buttons
Color? colorOfBackIconsOfSmallButtons = iconColor;

///size of back icons of small buttons
double? sizeOfBackIconOfSmallButtons(widget) => isPressed
    ? widget.iconSize != null
    ? widget.iconSize! - 4
    : 18
    : widget.iconSize != null
    ? widget.iconSize!
    : 22;

///color of  icons of small buttons
 Color colorOfIconsOfSmallButtons = iconColor;

///size of  icons of small buttons
double? sizeOfIconOfSmallButtons(widget) => isPressed
    ? widget.iconSize != null
    ? widget.iconSize! - 4
    : 18
    : widget.iconSize != null
    ? widget.iconSize!
    : 22;
////////////////////////////////up and down dots of small buttons/////////////////////////
///to make up dot in the same direction in both arabic and english of small buttons
const TextDirection textDirectionOfUpDotOfSmallButton = TextDirection.ltr;

///end padding of up dot image of small button
double? endPaddingOfUpDotOfSmallButton(context) =>
    screenWidth(context, portraitPercent: 17);



///height of up dot image of small button
double? heightOfUpDotImageOfSmallButtons(widget) => widget.iconSize != null
    ? widget.iconSize! - (widget.iconSize! - 5)
    : 7;

///width of up dot image of small button
double? widthOfUpDotImageOfSmallButtons(widget) => widget.iconSize != null
    ? widget.iconSize! - (widget.iconSize! - 3)
    : 10;

///to make down dot in the same direction in both arabic and english of small buttons
const TextDirection textDirectionOfDownDotOfSmallButton = TextDirection.ltr;

///bottom padding of down dot of small buttons
double? bottomPaddingOfDownDotOfSmallButtons(context) =>
    screenHeight(context, portraitPercent: 12);

///start padding of down dot of small buttons
double? startPaddingOfDownDotOfSmallButtons(context) =>
    screenWidth(context, portraitPercent: 13);

///height of down dot image of small button
double? heightOfDownDotImageOfSmallButtons(widget) => widget.iconSize != null
    ? widget.iconSize! - (widget.iconSize! / 1.2)
    : 4;

///width of down dot image of small button
double? widthOfDownDotImageOfSmallButtons(widget) =>
    widget.iconSize != null ? widget.iconSize! - (widget.iconSize! / 10) : 5;

class DefaultBackButton extends StatefulWidget {
  final void Function()? onPressed;
  final double? width;
  final double? height;
  bool isOutsideHome;
  final double? iconSize;
  final Widget? centerWidget;
  final IconData? icon;
  final double radius;

   DefaultBackButton({
    Key? key,
    this.icon,
    required this.onPressed,
    this.centerWidget,
    this.isOutsideHome = false,
    this.iconSize,
    this.height,
    this.width,
    this.radius = 40,
  }) : super(key: key);

  @override
  State<DefaultBackButton> createState() => _DefaultBackButtonState();
}

bool isPressed = false;

class _DefaultBackButtonState extends State<DefaultBackButton> {
  @override
  void initState() {
    super.initState();
    isPressed = false;
  }
  Future<bool> getVisibility() async {
    if(await GlobalCubit.get(context).webViewControllerList![GlobalCubit.get(context).bottomNavIndex]!.canGoBack()) {
      return true;
    }else return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isOutsideHome ?
         GestureDetector(
      onTap:  widget.onPressed == null
          ? null
          : onTapOfSmallButtons(setState, widget),
      child: AnimatedContainer(
        duration: durationOfMainAnimatedContainerOfSmallButtons,
        alignment: alignmentOfMainAnimatedContainerOfSmallButtons,
        height: heightOfMainAnimatedContainerOfSmallButtons(widget, context),
        width:heightOfMainAnimatedContainerOfSmallButtons(widget, context),
        padding: paddingOfMainAnimatedContainerOfSmallButtons,
        clipBehavior: widget.centerWidget == null?
        clipBehaviorOfOfContentedAnimatedContainerOfSmallButtons : Clip.none,
        decoration: decorationOfMainAnimatedContainerOfSmallButtons(widget),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: durationOfContentedAnimatedContainerOfSmallButtons,
              alignment: alignmentOfContentedAnimatedContainerOfSmallButtons,
              padding: paddingOfContentedAnimatedContainerOfSmallButtons,
              clipBehavior: widget.centerWidget == null?
              clipBehaviorOfOfContentedAnimatedContainerOfSmallButtons : Clip.none,
              decoration:
              decorationOfContentedAnimatedContainerOfSmallButtons(widget),
              child:
              widget.centerWidget ??
                  Stack(
                    fit: fitOfContentedAnimatedContainerOfSmallButtons,
                    children: [
                      Center(
                        child: Padding(
                          padding:
                          paddingOfStackOfContentedAnimatedContainerOfSmallButtons(
                              context),
                          child: Icon(
                            widget.icon,
                            color: colorOfBackIconsOfSmallButtons,
                            size: sizeOfBackIconOfSmallButtons(widget)!,
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          widget.icon,
                          color: iconColor,
                          size: sizeOfIconOfSmallButtons(widget)!,
                        ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    ) : FutureBuilder<bool>(
        future: getVisibility(), // Pass your visibility Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          } else if (snapshot.hasError) {
            return SizedBox();
          } else {
            final bool visible = snapshot.data ?? false; // Default to hidden
            return Visibility(
          visible: visible,
          replacement: SizedBox(),
          child: GestureDetector(
            onTap:  widget.onPressed == null
                ? null
                : onTapOfSmallButtons(setState, widget),
            child: AnimatedContainer(
              duration: durationOfMainAnimatedContainerOfSmallButtons,
              alignment: alignmentOfMainAnimatedContainerOfSmallButtons,
              height: heightOfMainAnimatedContainerOfSmallButtons(widget, context),
              width:heightOfMainAnimatedContainerOfSmallButtons(widget, context),
              padding: paddingOfMainAnimatedContainerOfSmallButtons,
              clipBehavior: clipBehaviorOfMainAnimatedContainerOfSmallButtons,
              decoration: decorationOfMainAnimatedContainerOfSmallButtons(widget),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: durationOfContentedAnimatedContainerOfSmallButtons,
                    alignment: alignmentOfContentedAnimatedContainerOfSmallButtons,
                    padding: paddingOfContentedAnimatedContainerOfSmallButtons,
                    clipBehavior:
                    clipBehaviorOfOfContentedAnimatedContainerOfSmallButtons,
                    decoration:decorationOfContentedAnimatedContainerOfSmallButtons(widget),
                    child:
                    widget.centerWidget ??
                        Stack(
                          fit: fitOfContentedAnimatedContainerOfSmallButtons,
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                paddingOfStackOfContentedAnimatedContainerOfSmallButtons(
                                    context),
                                child: Icon(
                                  widget.icon,
                                  color: colorOfBackIconsOfSmallButtons,
                                  size: sizeOfBackIconOfSmallButtons(widget)!,
                                ),
                              ),
                            ),
                            Center(
                              child: Icon(
                                widget.icon,
                                color: iconColor,
                                size: sizeOfIconOfSmallButtons(widget)!,
                              ),
                            ),
                          ],
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
        }
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}