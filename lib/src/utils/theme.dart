import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xffdae6ef);
  static const Color accentColor = Color(0xffAF252D);

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
