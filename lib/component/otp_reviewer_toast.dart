import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubit/otp_cubit/cubit.dart';
import '../cubit/otp_cubit/states.dart';
import '../main.dart';
import '../utils/loader.dart';
import 'avatar_glow.dart';

class OTPToast extends StatelessWidget {
  const OTPToast({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<OTPCubit, OTPStates>(
        listener: (context, otpState) {},
        builder: (context, otpState) {
         return Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    if (otpState is LoadingToastState ||
                        otpState is ErrorOTPResponseState)
                      _buildToast(context, Colors.yellow,
                          OTPCubit.get(context).waitingToastMsg ?? ''),
                    if (otpState is SuccessOTPResponseState)
                      _buildToast(context, Colors.green,
                          OTPCubit.get(context).otpToastMsg ?? ''),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildToast(BuildContext context, Color color, String? message) {
    return Material(
      color: Colors.transparent,
      child: Dismissible(
        key: Key('value'),
        onDismissed: (d){
          OTPCubit.get(context).dismissToast();
        },
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            SizedBox(
              height: context.height() * 0.2,
              child: AvatarGlow(
                endRadius: context.width(),
                shape: BoxShape.rectangle,
                glowColor: color,
                child: PositionedDirectional(
                  top: 0,
                  width: context.width(),
                  height: context.height() * 0.2,
                  child: Container(
      
                    padding: EdgeInsets.all(context.height() * 0.02),
                    margin: EdgeInsets.all(context.height() * 0.02),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: color,
                            width: 2
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.1),
                            spreadRadius: 5,
                            offset: Offset(0,5),
                            blurRadius: 3,
                          )
                        ]
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              message ?? '--',
                              maxLines: 4,
      
                              style: TextStyle(
                                color: Colors.black,
      
                              ),
                            ),
                            if(message!.contains('wait'))
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Loaders().center(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.height() * 0.01),
              child: IconButton(
                onPressed: (){
                  OTPCubit.get(context).dismissToast();
                },
                icon: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
