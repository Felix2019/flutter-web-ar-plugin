import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/utilities.dart';

abstract class ThreeScene {
  void addElement(Mesh object);
}

class SceneController implements ThreeScene {
  final Scene scene = Scene();
  final List<Mesh> _objects = [];

  List<Mesh> get activeObjects => _objects;

  set backgroundColor(Color color) => scene.background = color;

  @override
  void addElement(Mesh object) {
    scene.add(object);
    _objects.add(object);
  }

  // @override
  // void multiplyObject(
  //     {required List<MeshBasicMaterial> materials,
  //     required BoxGeometry geometry}) {
  //   const rowCount = 4;
  //   const half = rowCount / 2;

  //   for (var i = 0; i < rowCount; i++) {
  //     for (var j = 0; j < rowCount; j++) {
  //       for (var k = 0; k < rowCount; k++) {
  //         final Mesh object = Mesh(geometry, materials[0]);

  //         object.position.x = i - half;
  //         object.position.y = j - half;
  //         object.position.z = k - half;

  //         object.rotation.x += 7;
  //         object.rotation.y += 7;

  //         scene.add(object);
  //         objects.add(object);
  //       }
  //     }
  //   }
  // }
}
