import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';

// ignore: must_be_immutable
class Loaders extends StatelessWidget {
  String? name;

  Loaders({this.name = 'FadingCircle'});

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    if (name == 'RotatingPlane') {
      child = SpinKitRotatingPlain(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'DoubleBounce') {
      child = SpinKitDoubleBounce(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'Wave') {
      child = SpinKitWave(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'WanderingCubes') {
      child = SpinKitWanderingCubes(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'Pulse') {
      child = SpinKitPulse(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'ChasingDots') {
      child = SpinKitChasingDots(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'FadingFour') {
      child = SpinKitFadingFour(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'Circle') {
      child = SpinKitCircle(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'CubeGrid') {
      child = SpinKitCubeGrid(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'FadingCircle') {
      child = SpinKitFadingCircle(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'FoldingCube') {
      child = SpinKitFoldingCube(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'RotatingCircle') {
      child = SpinKitRotatingCircle(
        size: 30.0,
        color: iconColor,
      );
    } else if (name == 'Ring') {
      child = SpinKitRing(
        size: 30.0,
        color: iconColor,
      );
    }
    return Center(
      child: Container(
        height: 150,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}