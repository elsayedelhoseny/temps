import 'package:flutter/material.dart';

@immutable
abstract class InternetStates {}

class InternetInitial extends InternetStates {}

class CheckerLoading extends InternetStates {}

class TryingToReconnecting extends InternetStates {}

class ReConnectedState extends InternetStates {}

class StillNotConnectedState extends InternetStates {}

class NotConnectedState extends InternetStates {}

class InternetChecked extends InternetStates {}

class NoInternetChecked extends InternetStates {}
