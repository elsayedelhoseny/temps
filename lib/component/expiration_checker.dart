import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/NoInternetConnection.dart';
import '../cubit/internet_checker_cubit/cubit.dart';
import '../cubit/internet_checker_cubit/states.dart';
import '../app_localizations.dart';
import '../cubit/Global/cubit.dart';
import '../cubit/Global/states.dart';
import '../screen/ErrorScreen.dart';
import '../utils/constant.dart';
import '../utils/images.dart';

class ExpirationChecker extends StatelessWidget {
  final Widget child;
  const ExpirationChecker({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetCubit, InternetStates>(
        listener: (context, state) {},
    builder: (context, state) {
    if (state is NoInternetChecked) {
    return NoInternetConnection();
    } else {
        return BlocConsumer<GlobalCubit, GlobalStates>(
            listener: (context, state) {},
            builder: (context, state) {
          return (currentDate.isAfter(expirationDate) || (GlobalCubit.get(context).isBlocked ?? false))?
              ErrorScreen(
                  errorImage: GlobalCubit.get(context).isBlocked! ?
                  blockedError : null,
                  withoutColor: true,
                  error:
                  AppLocalizations.of(context)!.translate('msg_time_out'))
              : child;

            }
        );
    }
      }
    );
  }
}
