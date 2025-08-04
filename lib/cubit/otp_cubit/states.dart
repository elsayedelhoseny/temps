import 'package:flutter/material.dart';

@immutable
abstract class OTPStates {}

class OTPCubitInitial extends OTPStates {}
class LoadingToastState extends OTPStates {}
class SuccessOTPResponseState extends OTPStates {}
class ErrorOTPResponseState extends OTPStates {}
class EndOTPState extends OTPStates {}
