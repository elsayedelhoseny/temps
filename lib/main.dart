import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppTheme.dart';
import '../app_localizations.dart';
import '../cubit/internet_checker_cubit/cubit.dart';
import '../model/LanguageModel.dart';
import '../screen/main_layout.dart';
import '../utils/AppWidget.dart';
import '../utils/cacheHelper/cache_helper.dart';
import '../utils/common.dart';
import '../utils/constant.dart';
import 'cubit/Global/cubit.dart';
import 'cubit/Global/states.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/otp_cubit/cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  HttpOverrides.global = HttpOverridesSkipCertificate();
  currentDate = DateTime.now();
  await initialize();
  getCacheData();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  initialOneSignal();
  // CacheHelper.removeData(key: "modelHashValue");
  // CacheHelper.removeData(key: "endOnboarding");
  // CacheHelper.removeData(key: "endprivacyPolicy");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (BuildContext context) => GlobalCubit()..initial(),
        // ),

        BlocProvider(
          create: (BuildContext context) => GlobalCubit()..init(),
        ),

        BlocProvider(
          create: (BuildContext context) => InternetCubit(),
        ),

        BlocProvider(
          create: (BuildContext context) => OTPCubit(),
        ),
      ],
      child: BlocConsumer<GlobalCubit, GlobalStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) =>
                  debuggingErrorBuilder(context, child),
              home: MainLayoutScreen(),
              supportedLocales: Language.languagesLocale(),
              navigatorKey: navigatorKey,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) => locale,
              locale: Locale('ar'),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              scrollBehavior: SBehavior(),
            );
          }),
    );
  }
}
