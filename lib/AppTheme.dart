import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    hoverColor: Colors.grey,
    fontFamily: GoogleFonts.cairo().fontFamily,
    appBarTheme: AppBarTheme(
      color: primaryColor,
     // brightness: appStore.primaryColors.isDark() ? Brightness.dark : Brightness.light,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    cardTheme: CardTheme(color: Colors.white),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF131d25),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      //brightness: appStore.primaryColors.isDark() ? Brightness.dark : Brightness.light,
    ),
    primaryColor: primaryColor,
    fontFamily: GoogleFonts.cairo().fontFamily,
    cardTheme: CardTheme(color: Color(0xFF1D2939)),
    iconTheme: IconThemeData(color: Colors.white70),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
