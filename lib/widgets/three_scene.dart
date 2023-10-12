import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/loader_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/utils/interop_utils.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class ThreeScene extends StatefulWidget {
  final String createdViewId;
  final Mesh? object;
  final String? path;

  const ThreeScene(
      {super.key, required this.createdViewId, this.object, this.path});

  @override
  State<ThreeScene> createState() => _ThreeSceneState();
}

class _ThreeSceneState extends State<ThreeScene> {
  final html.CanvasElement canvas = html.CanvasElement();

  late RendererController rendererController;

  final SceneController sceneController = SceneController();
  final CameraController cameraController =
      CameraController(matrixAutoUpdate: true);
  final LoaderController loaderController = LoaderController();

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
    cameraController.setPosition(null, null, 6);
  }

  Future<void> addElement() async {
    if (widget.object != null) sceneController.addElement(widget.object!);

    if (widget.path != null) {
      try {
        dynamic model =
            await loaderController.loadModel('models/shiba/scene.gltf');

        domLog(model);

        sceneController.addElement(model);

        rendererController.animate(sceneController.scene,
            cameraController.perspectiveCamera, model, 0, 0.04);
      } catch (error) {
        domLog("scheies");
        domLog(error);
      }
    }
  }

  void animate() {
    if (widget.object == null) return;
    rendererController.animate(sceneController.scene,
        cameraController.perspectiveCamera, widget.object!, 0.04, 0.04);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.createdViewId);
  }
}
