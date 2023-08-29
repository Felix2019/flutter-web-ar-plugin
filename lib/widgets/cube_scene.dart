import 'dart:html';
import 'dart:js_util';
import 'package:flutter_web_xr/three_manager.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class CubeScene extends StatefulWidget {
  const CubeScene({super.key});

  @override
  State<CubeScene> createState() => _CubeSceneState();
}

class _CubeSceneState extends State<CubeScene> {
  final html.CanvasElement canvas = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.backgroundColor = 'blue';

  late WebGLRenderer renderer;
  late Scene scene;
  late PerspectiveCamera camera;
  late Mesh cube;

  String createdViewId = 'div';
  late Object? gl;

  @override
  void initState() {
    super.initState();
    registerCanvas();

    initRenderer();
    initScene();
    initCamera();

    render();
  }

  void registerCanvas() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => canvas);
  }

  void initRenderer() {
    gl = canvas.getContext('webgl', {'xrCompatible': true});

    final Object options = jsify({
      'context': gl,
      'canvas': canvas,
      'alpha': true,
      'preserveDrawingBuffer': true,
    });

    renderer = WebGLRenderer(options);

    // Setzen Sie die Größe des Renderers auf die Größe des Canvas-Elements
    renderer.setSize(
        window.innerWidth!.toDouble(), window.innerHeight!.toDouble());

    // html.CanvasElement canvas = renderer.domElement;
    // gl = canvas.getContext('webgl', {'xrCompatible': true});
    // add the created canvas to the html document body
    // container.append(canvas);
  }

  void initScene() {
    scene = Scene();
    scene.background = Color('pink');
    addElement();
  }

  void initCamera() {
    camera = PerspectiveCamera(
        50, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    camera.position.z = 10;
    scene.add(camera);
  }

  void addElement() {
    final materials = [
      MeshBasicMaterial(jsify({'color': 0xff0000})),
      MeshBasicMaterial(jsify({'color': 0x0000ff})),
      MeshBasicMaterial(jsify({'color': 0x00ff00})),
      MeshBasicMaterial(jsify({'color': 0xff00ff})),
      MeshBasicMaterial(jsify({'color': 0x00ffff})),
      MeshBasicMaterial(jsify({'color': 0xffff00}))
    ];

    final geometry = BoxGeometry(1, 1, 1);
    cube = Mesh(geometry, materials);
    scene.add(cube);
  }

  void animate() {
    cube.rotation.x += 0.07;
    cube.rotation.y += 0.07;
  }

  void render() {
    renderer.render(scene, camera);
    animate();
    Future.delayed(const Duration(milliseconds: 40), () {
      render();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cube Scene'),
      ),
      body: SizedBox(
        height: 200,
        width: 200,
        child: HtmlElementView(viewType: createdViewId),
      ),
    );
  }
}
