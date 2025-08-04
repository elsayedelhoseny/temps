import 'dart:math';
import 'package:flutter/material.dart';

class Responsive {
  Responsive({
    this.designWidth = 428,
    this.designHeight = 926,
  });

  final double designWidth;
  final double designHeight;

  double w(num width, BuildContext context) {
    final view = View.of(context);
    return width *
        (view.physicalSize.width / view.devicePixelRatio / designWidth);
  }

  double h(num height, BuildContext context) {
    final view = View.of(context);
    return height *
        (view.physicalSize.height / view.devicePixelRatio / designHeight);
  }

  double fs(num size, BuildContext context) {
    final view = View.of(context);
    return min(
      size * (view.physicalSize.height / view.devicePixelRatio / designHeight),
      size * (view.physicalSize.width / view.devicePixelRatio / designWidth),
    );
  }
}

extension SizeExtension on num {
  double w(BuildContext context) {
    final view = View.of(context);
    final orientation = view.physicalSize.width > view.physicalSize.height
        ? Orientation.landscape
        : Orientation.portrait;

    return orientation == Orientation.landscape
        ? Responsive(designHeight: 428, designWidth: 926).w(this, context)
        : Responsive().w(this, context);
  }

  double h(BuildContext context) {
    final view = View.of(context);
    final orientation = view.physicalSize.width > view.physicalSize.height
        ? Orientation.landscape
        : Orientation.portrait;

    return orientation == Orientation.landscape
        ? Responsive(designHeight: 428, designWidth: 926).h(this, context)
        : Responsive().h(this, context);
  }

  double fs(BuildContext context) {
    final view = View.of(context);
    final orientation = view.physicalSize.width > view.physicalSize.height
        ? Orientation.landscape
        : Orientation.portrait;

    return orientation == Orientation.landscape
        ? Responsive(designHeight: 428, designWidth: 926).fs(this, context)
        : Responsive().fs(this, context);
  }
}
