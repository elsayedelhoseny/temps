import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ntp/ntp.dart';
import '../../config_file.dart';
import '../../cubit/otp_cubit/states.dart';
import '../../model/otp_model.dart';
import '../../network/dio_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class OTPCubit extends Cubit<OTPStates> {
  OTPCubit() : super(OTPCubitInitial());

  static OTPCubit get(BuildContext context) => BlocProvider.of(context);

  String? otpToastMsg;
  String? waitingToastMsg;
  OTPModel? otpModel;

  Future<void> initiateOTPRequest() async {
    otpModel = null;

    tz.initializeTimeZones();
    final cairoTimeZone = tz.getLocation('Africa/Cairo');

    try {
      // Get the current time from the NTP server
      DateTime nowUtc = await NTP.now();

      // Convert the time to Cairo (UTC +2)
      final nowCairo = tz.TZDateTime.from(nowUtc, cairoTimeZone);
      timestamp = nowCairo.millisecondsSinceEpoch ~/ 1000;

      print(timestamp); // Debugging
      print("timestamp"); // Debugging
      requestOTPCode(otpMail: otpMail); // Start OTP request
    } catch (e) {
      print("Error getting time: $e");
      emit(ErrorOTPResponseState());
    }
  }

  int? timestamp;

  Future<void> requestOTPCode({String? otpMail}) async {
    await Future.delayed(
      Duration(seconds: 10),
    );
    waitingToastMsg = "Loading Reviewer OTP code,"
        "\n this process may take 1 min"
        "\n please don\'t resend and wait...";
    emit(LoadingToastState());
    try {
      print('======================================================$timestamp');
      final response = await DioHelper.getData(
        url: 'get-otp',
        query: {
          'email_account': otpMail,
          'token':
              'kyAm3M5vUxlU1vkMqRYs954UY3RcGVvvYevWDySHp8SO2lZgJwBbRGELyRO2U',
          'timestamp': timestamp
        },
      );

      otpModel = OTPModel.fromJson(response.data);
      print(otpModel!.toJson().toString());
      emit(LoadingToastState());
      if (otpModel?.error?.isNotEmpty ?? false) {
        await Future.delayed(Duration(seconds: 20));
        if (state is! EndOTPState) requestOTPCode(otpMail: otpMail);
      } else {
        otpToastMsg =
            "Your OTP code for email: $otpMail \n is ${otpModel?.otp ?? '- - - -'}";
        print(otpToastMsg);
        emit(SuccessOTPResponseState());
        otpModel = null;
        emit(SuccessOTPResponseState());
      }
    } catch (error) {
      print(error.toString());
      emit(ErrorOTPResponseState());
      await Future.delayed(Duration(seconds: 2));
      requestOTPCode(otpMail: otpMail);
    }
  }

  void dismissToast() {
    emit(EndOTPState());
  }
}
