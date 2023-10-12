import 'package:flutter_web_xr/widgets/three_scene.dart';

class ThreeJSModel {
  final String name;
  final ThreeScene scene;
  bool isSelected;

  ThreeJSModel(
      {required this.name, required this.scene, this.isSelected = false});
}
