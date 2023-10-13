import 'package:flutter_web_xr/widgets/three_scene.dart';

class ThreeModel {
  final String name;
  final Function startARSession;
  final ThreeScene scene;

  ThreeModel({
    required this.name,
    required this.startARSession,
    required this.scene,
  }) : assert(name.isNotEmpty, 'Model name must not be empty.');
}
