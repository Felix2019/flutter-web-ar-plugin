import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';

class ThreeUtils {
  static List<MeshBasicMaterial> createMaterials() => [
        MeshBasicMaterial(jsify({'color': 0xff0000})),
        MeshBasicMaterial(jsify({'color': 0x0000ff})),
        MeshBasicMaterial(jsify({'color': 0x00ff00})),
        MeshBasicMaterial(jsify({'color': 0xff00ff})),
        MeshBasicMaterial(jsify({'color': 0x00ffff})),
        MeshBasicMaterial(jsify({'color': 0xffff00}))
      ];

  // static Mesh createCube({required double sideLength}) {
  //   final geometry = BoxGeometry(sideLength, sideLength, sideLength);
  //   return Mesh(geometry, createMaterials());
  // }

  // static Mesh createCone({required double radius, required double height}) {
  //   final geometry = ConeGeometry(radius, height, 32);
  //   return Mesh(geometry, createMaterials());
  // }
}
