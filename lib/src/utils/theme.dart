import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/utils/colors.dart';

class CustomTheme {
  static AppBarTheme appBarTheme = const AppBarTheme(
      backgroundColor: Palette.primaryColor,
      iconTheme: IconThemeData(color: Colors.black, size: 28),
      actionsIconTheme: IconThemeData(color: Colors.black),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold));

  static final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
        // fontSize: 15,
        fontWeight: FontWeight.bold)),
    backgroundColor: MaterialStateProperty.all<Color>(Palette.accentColor),
    // shape: MaterialStateProperty.all<OutlinedBorder>(
    //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  ));

  static final floatinActionButtonTheme = FloatingActionButtonThemeData(
    elevation: 1,
    backgroundColor: Palette.accentColor,
    extendedTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static const TextTheme textTheme = TextTheme(
    displayMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
    displaySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
    titleLarge:
        TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 20),
    titleMedium: TextStyle(fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  );

  // tailwind default shadow
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 2.0,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
  ];

  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(12.0));
}
