import 'package:flutter/material.dart';

class MainColor {
  // textos
  static Color primary = const Color(0xff15365A);
  static Color secondary = const Color(0xff27AD7B);
  static Color warning = const Color(0xffFAD02C);
  static Color info = const Color(0xff15877F);
  static Color light = Colors.white;
  static Color lightSubtle = Colors.grey.withOpacity(0.5);
  static Color dark = Colors.black;
  static Color darkSubtle = Colors.grey.shade400;

  //backgrounds
  static Color bgPrimary = const Color(0xffF7F7F7);
  static Color bgSecondary = const Color(0xff27AD7B);

  static Color transparent = Colors.transparent;

  // color para el fondo del loading img
  static Color backgroundColorLoadingImg = const Color(0xffE6E6E6);

  static BoxShadow mainShadow = const BoxShadow(
    color: Colors.white,
    offset: Offset(-3.0, -3.0),
    blurRadius: 5.0,
    spreadRadius: 3,
  );

  static BoxShadow secundaryShadow = BoxShadow(
    color: Colors.black.withOpacity(0.6),
    offset: const Offset(3.0, 3.0),
    blurRadius: 5.0,
    spreadRadius: -3.5,
  );

  static BoxShadow errorShadow = BoxShadow(
    color: Colors.red.withOpacity(0.6),
    offset: const Offset(-6.0, -6.0),
    blurRadius: 16.0,
  );

  static BoxShadow errorSecundaryShadow = BoxShadow(
    color: Colors.red.withOpacity(0.8),
    offset: const Offset(6.0, 6.0),
    blurRadius: 16.0,
  );

  static LinearGradient inputGradient = LinearGradient(
    colors: [
      bgPrimary,
      bgPrimary,
      bgPrimary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 0.5, 1.0],
    tileMode: TileMode.clamp,
  );

  static LinearGradient mainGradient = const LinearGradient(
    colors: [
      Color(0xffffffff),
      Color(0xff000000),
      Color(0xff000000),
      Color(0xffffffff),
    ],
    begin: Alignment(-1, -0.9),
    end: Alignment(1, 0.8),
    stops: [0.0, 0.3, 0.6, 1.0],
    tileMode: TileMode.clamp,
  );
}
