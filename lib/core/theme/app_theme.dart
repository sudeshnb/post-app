import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:poetic_app/core/theme/dark_theme.dart';
import 'package:poetic_app/core/theme/light_theme.dart';

class AppTheme {
  // static Color lightBackgroundColor = Colors.white;
  // static Color lightPrimaryColor = const Color(0xfff2f2f2);
  // static Color lightAccentColor = Colors.blueGrey.shade200;
  // static Color lightParticlesColor = const Color(0x44948282);

  // static Color darkBackgroundColor = const Color(0xFF1A2127);
  // static Color darkBackgroundColor = const Color.fromRGBO(19, 28, 33, 1);
  // static Color darkPrimaryColor = const Color(0xFF1A2127);
  // static Color darkAccentColor = Colors.blueGrey.shade600;
  // static Color darkParticlesColor = const Color(0x441C2A3D);

  // static Color logoTextColor = textColor.withOpacity(0.5);

  const AppTheme._();

  static final lightTheme = ThemeData(
    fontFamily: 'avenir',
    brightness: Brightness.light,
    // primaryColor: lightPrimaryColor,
    backgroundColor: LightColor.backgroundColor,
    scaffoldBackgroundColor: LightColor.scaffoldBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: LightColor.textBoxColor,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: LightColor.backgroundColor,
        iconTheme: IconThemeData(color: LightColor.iconColor)
        // color: LightColor.backgroundColor,
        ),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'avenir',
    brightness: Brightness.dark,
    backgroundColor: DarkColor.backgroundColor,
    scaffoldBackgroundColor: DarkColor.scaffoldBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: LightColor.textBoxColor,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: DarkColor.backgroundColor,
        iconTheme: IconThemeData(color: LightColor.iconColor)
        // color: LightColor.backgroundColor,
        ),
  );

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance!.window.platformBrightness;

  static setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      // systemNavigationBarColor: themeMode == ThemeMode.light
      //     ? lightBackgroundColor
      //     : darkBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }
}

extension ThemeExtras on ThemeData {
  // *****************************************
  Color get textBoxColor => brightness == Brightness.light
      ? LightColor.textBoxColor
      : LightColor.blueButtonColor;
  Color get phoneCodeColor => brightness == Brightness.light
      ? LightColor.iconColor
      : LightColor.scaffoldBackgroundColor;

  Color get textColor => brightness == Brightness.light
      ? LightColor.textColor
      : DarkColor.textColor;

  //  Icons color
  Color get iconColor => brightness == Brightness.light
      ? LightColor.iconColor
      : DarkColor.iconColor;
  // BottomAppBar
  Color get btnSelectColor => brightness == Brightness.light
      ? LightColor.maroon
      : DarkColor.blueButtonColor;

  // BottomAppBar
  Color get borderColor => brightness == Brightness.light
      ? LightColor.blueButtonColor
      : DarkColor.blueButtonColor;
  // BottomAppBar
  Color get btnUnselectColor => brightness == Brightness.light
      ? LightColor.btnUnselectColor
      : LightColor.blueButtonColor;
  // *******************************************
  Color get particlesColor => brightness == Brightness.light
      ? LightColor.scaffoldBackgroundColor
      : DarkColor.scaffoldBackgroundColor;

  //  Heading Text
  Color get logoTextColor => brightness == Brightness.light
      ? LightColor.burgundy
      : LightColor.blueButtonColor;
  // BottomAppBar
  Color get bAppBarColor => brightness == Brightness.light
      ? LightColor.blueButtonColor
      : LightColor.blueButtonColor;

  // BottomAppBar

  // BottomAppBar

}

// const darkAppBarColor = Color.fromRGBO(31, 44, 52, 1);
// const Color lightAppBarColor = Color(0xfff2f2f2);
// const primaryWhiteColor = Colors.white;
// const greyColor = Colors.grey;
// const Color lightGeay = Color(0xFFf7f7f7);
// const Color darkBackgroundColor = Color(0xFF1A2127);
// // .fromARGB(223, 216, 218, 219)

// const Color lightScaffoldBackgroundColor = Color(0xFFF5F6F7);

// const iosLightGray = Color(0xFF8E8E93);
// //RGB VALUE const Color.fromRGBO(142, 142, 147, 1);
// const iosLightGray2 = Color(0xFFAEAEB2);
// //RGB VALUE const Color.fromRGBO(174, 174, 178, 1);
// const iosLightGray3 = Color(0xFFC7C7CC);
// //RGB VALUE const Color.fromRGBO(199, 199, 204, 1);
// const iosLightGray4 = Color(0xFFD1D1D6);
// //RGB VALUE const Color.fromRGBO(209, 209, 214, 1);
// const iosLightGray5 = Color(0xFFE5E5EA);
// //RGB VALUE const Color.fromRGBO(229, 229, 234, 1);
// const iosLightGray6 = Color(0xFFF2F2F7);
// //RGB VALUE const Color.fromRGBO(242, 242, 247, 1);

// const iosDarkGray = Color(0xFF8E8E93);
// //RGB VALUE const Color.fromRGBO(142, 142, 147, 1);
// const iosDarkGray2 = Color(0xFF636366);
// //RGB VALUE const Color.fromRGBO(99, 99, 102, 1);
// const iosDarkGray3 = Color(0xFF48484A);
// //RGB VALUE const Color.fromRGBO(72, 72, 74, 1);
// const iosDarkGray4 = Color(0xFF3A3A3C);
// //RGB VALUE const Color.fromRGBO(58, 58, 60, 1);
// const iosDarkGray5 = Color(0xFF2C2C2E);
// //RGB VALUE const Color.fromRGBO(44, 44, 46, 1);
// const iosDarkGray6 = Color(0xFF1C1C1E);
// //RGB VALUE const Color.fromRGBO(28, 28, 30, 1);