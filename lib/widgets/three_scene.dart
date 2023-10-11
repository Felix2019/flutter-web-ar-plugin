import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

// three/examples/jsm/loaders/GLTFLoader

class ThreeScene extends StatefulWidget {
  final String createdViewId;
  final Mesh? object;

  const ThreeScene({super.key, required this.createdViewId, this.object});

  @override
  State<ThreeScene> createState() => _ThreeSceneState();
}

class _ThreeSceneState extends State<ThreeScene> {
  final html.CanvasElement canvas = html.CanvasElement();

  late RendererController rendererController;
  final SceneController sceneController = SceneController();
  final CameraController cameraController =
      CameraController(matrixAutoUpdate: true);

  @override
  void initState() {
    super.initState();
    rendererController = RendererController(canvas: canvas);

    registerCanvas();
    configureCamera();
    addElement();
    animate();
  }

  void registerCanvas() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(widget.createdViewId, (int viewId) => canvas);
  }

  void configureCamera() {
    cameraController.setPosition(null, null, 5);
  }

  void addElement() {
    // final geometry = BoxGeometry(1, 1, 1);
    // object = Mesh(geometry, createMaterials());

    // check whether object is null
    if (widget.object == null) {
      print("no object is available");
    } else {
      sceneController.addElement(widget.object!);
    }
  }

  void animate() {
    rendererController.animate(sceneController.scene,
        cameraController.perspectiveCamera, widget.object!);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.createdViewId);
  }
}
