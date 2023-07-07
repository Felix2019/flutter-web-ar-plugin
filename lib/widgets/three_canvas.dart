import 'dart:html';
import 'dart:js_util';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/test.dart';
import 'package:flutter_web_xr/three_manager.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter_web_xr/web_xr_manager.dart';

class MyCanvasTest extends StatefulWidget {
  const MyCanvasTest({super.key});

  @override
  State<MyCanvasTest> createState() => _MyCanvasTestState();
}

class _MyCanvasTestState extends State<MyCanvasTest> {
  final html.CanvasElement canvas1 = html.CanvasElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.backgroundColor = 'blue';

  final html.DivElement container = html.DivElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.backgroundColor = 'red';

  late WebGLRenderer renderer;
  late Scene scene;
  late PerspectiveCamera camera;
  late Mesh cube;

  String createdViewId = 'div';
  late Object? gl;
  late Object? xrSession;

  @override
  void initState() {
    super.initState();
    registerDiv();

    initRenderer();
    initScene();
    initCamera();

    addElement();

    startXRSession();
    render();
  }

  void registerDiv() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => canvas1);
    // ui.platformViewRegistry
    //     .registerViewFactory(createdViewId, (int viewId) => container);
  }

  void initRenderer() {
    gl = canvas1.getContext('webgl', {'xrCompatible': true});

    final Object options = jsify({'context': gl, 'canvas': canvas1});

    renderer = WebGLRenderer(options);
    // Setzen Sie die Größe des Renderers auf die Größe des Canvas-Elements
    renderer.setSize(
        window.innerWidth!.toDouble(), window.innerHeight!.toDouble());

    renderer.xr.enabled = true;
    var controller = renderer.xr.getController(0);
    test1(controller);

    // html.CanvasElement canvas = renderer.domElement;
    // // create a webgl2 context
    // gl = canvas.getContext('webgl', {'xrCompatible': true});
    // test1(gl);

    // add the created canvas to the html document body
    // container.append(canvas);
  }

  void initScene() {
    scene = Scene();
    scene.background = Color('pink');
  }

  void initCamera() {
    camera = PerspectiveCamera(
        75, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    camera.position.z = 250;
    scene.add(camera);
  }

  void addElement() {
    final geometry = BoxGeometry(75, 75, 75);
    final material = MeshBasicMaterial(jsify({'color': 0x00ff00}));
    cube = Mesh(geometry, material);
    scene.add(cube);
  }

  void animate() {
    cube.rotation.x += 0.07;
    cube.rotation.y += 0.07;
  }

  void render() {
    animate();
    renderer.render(scene, camera);

    // Future.delayed(Duration(seconds: 1), () {
    //   callMethod(xrSession!, 'requestAnimationFrame', [allowInterop(render)]);
    // });
    // Future.delayed(const Duration(milliseconds: 40), () => render());
  }

  void startXRSession() {
    // var sessionInit = XRSessionInit(immersiveAr: true); as option parameter in requestSession
    FlutterWebXr().requestSession().then(allowInterop((session) async {
      setState(() => xrSession = session);

      final xrLayer = XRWebGLLayer(session, gl);

      // Create a XRRenderStateInit object with xrLayer as the baseLayer
      final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

      // Pass the XRRenderStateInit object to updateRenderState
      callMethod(session, 'updateRenderState', [renderStateInit]);

      // request the reference space
      const xrReferenceSpaceType = 'local';
      var xrReferenceSpace = await promiseToFuture(
          callMethod(session, 'requestReferenceSpace', [xrReferenceSpaceType]));

      // register XR-Frame-Handler
      startFrameHandler() {
        callMethod(session, 'requestAnimationFrame', [
          allowInterop((time, xrFrame) {
            render();
            startFrameHandler();
          })
        ]);
      }

      startFrameHandler();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HtmlElementView(viewType: createdViewId),
    );
  }
}


// The XRSession has completed multiple animation frames without drawing anything to the baseLayer's framebuffer, resulting in no visible output.
