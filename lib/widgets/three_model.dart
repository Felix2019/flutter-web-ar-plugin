import 'package:flutter/material.dart';

class ThreeJSModel {
  final String name;
  final String? path;
  final Widget scene;
  bool isSelected;

  ThreeJSModel(
      {required this.name,
      this.path,
      required this.scene,
      this.isSelected = false});
}
