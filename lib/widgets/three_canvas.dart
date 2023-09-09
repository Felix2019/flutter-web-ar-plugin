import 'dart:js_util';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/helper.dart';
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
  late Object? xrSession;

  @override
  void initState() {
    super.initState();
    registerCanvas();

    initRenderer();
    initScene();
    initCamera();

    // render();
    startXRSession();
  }

  void registerCanvas() {
    // Register div as a view and ensure the div is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => canvas);
  }

  void initRenderer() async {
    gl = canvas.getContext('webgl', {'xrCompatible': true});

    final Object options = jsify({
      'context': gl,
      'canvas': canvas,
      'alpha': true,
      'preserveDrawingBuffer': true,
    });

    renderer = WebGLRenderer(options);
    renderer.autoClear = false;
    renderer.xr.enabled = true;
  }

  void initScene() {
    scene = Scene();
    // scene.background = Color('pink');
    addElement();
  }

  void initCamera() {
    // camera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 1000);

    // camera = PerspectiveCamera(
    //     50, window.innerWidth! / window.innerHeight!, 0.1, 10);

    camera = PerspectiveCamera();
    camera.matrixAutoUpdate = false;

    // camera.position.x = 0;
    // camera.position.y = 2.5;
    // camera.position.z = 30;

    // camera.position. set( 0, 1.6, 3 );

    // scene.add(camera);
    // camera.matrixAutoUpdate = false;
  }

  List<Mesh> cubes = [];

  void addElement() {
    final materials = [
      MeshBasicMaterial(jsify({'color': 0xff0000})),
      MeshBasicMaterial(jsify({'color': 0x0000ff})),
      MeshBasicMaterial(jsify({'color': 0x00ff00})),
      MeshBasicMaterial(jsify({'color': 0xff00ff})),
      MeshBasicMaterial(jsify({'color': 0x00ffff})),
      MeshBasicMaterial(jsify({'color': 0xffff00}))
    ];

    const rowCount = 4;
    const spread = 1;
    const half = rowCount / 2;

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < rowCount; j++) {
        for (var k = 0; k < rowCount; k++) {
          final geometry = BoxGeometry(0.2, 0.2, 0.2);
          // final geometry = BoxGeometry(1, 1, 1);
          final box = Mesh(geometry, materials);

          box.position.x = i - half;
          box.position.y = j - half;
          box.position.z = k - half;

          box.rotation.x += 7;
          box.rotation.y += 7;

          // const box = new THREE.Mesh(new THREE.BoxBufferGeometry(0.2, 0.2, 0.2), materials);
          // box.position.set(i - half, j - HALF, k - HALF);
          // box.position.multiplyScalar(spread);
          scene.add(box);
          cubes.add(box);
        }
      }
    }

    // cube.rotation.x += 7;
    // cube.rotation.y += 7;
    // scene.add(cube);
  }

  void animate(Mesh cube) {
    cube.rotation.x += 0.03;
    cube.rotation.y += 0.03;
  }

  void render() {
    for (var i = 0; i < cubes.length; i++) {
      final cube = cubes[i];
      animate(cube);
    }
    renderer.render(scene, camera);
  }

  void startXRSession() {
    // var sessionInit = XRSessionInit(immersiveAr: true); as option parameter in requestSession
    FlutterWebXr().requestSession().then(allowInterop((session) async {
      setState(() => xrSession = session);

      log(session);

      final xrLayer = XRWebGLLayer(session, gl);

      // Create a XRRenderStateInit object with xrLayer as the baseLayer
      final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

      // Pass the XRRenderStateInit object to updateRenderState
      callMethod(session, 'updateRenderState', [renderStateInit]);

      // request the reference space
      const xrReferenceSpaceType = 'local';
      var xrReferenceSpace = await promiseToFuture(
          callMethod(session, 'requestReferenceSpace', [xrReferenceSpaceType]));

      log("requestReferenceSpace");

      // register XR-Frame-Handler
      startFrameHandler() {
        callMethod(session, 'requestAnimationFrame', [
          allowInterop((time, xrFrame) {
            startFrameHandler();

            // Bind the graphics framebuffer to the baseLayer's framebuffer.
            final renderState = getProperty(session, 'renderState');
            final baseLayer = getProperty(renderState, 'baseLayer');
            final framebuffer = getProperty(baseLayer, 'framebuffer');

            final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");
            callMethod(gl!, 'bindFramebuffer', [glFramebuffer, framebuffer]);

            log(glFramebuffer);

            // Retrieve the pose of the device.
            // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
            final pose =
                callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

            log(pose);

            if (pose != null) {
              // final xrTransform = pose.transform;
              // final xrPosition = xrTransform.position;
              // final xrOrientation = xrTransform.orientation;

              // camera.position.x = xrPosition.x;
              // camera.position.y = xrPosition.y;
              // camera.position.z = xrPosition.z;

              // In mobile AR, we only have one view.
              final views = getProperty(pose, 'views');

              final viewport = callMethod(baseLayer, 'getViewport', [views[0]]);

              final viewportWidth = getProperty(viewport, 'width');
              final viewportHeight = getProperty(viewport, 'height');
              renderer.setSize(viewportWidth, viewportHeight);

              // Aktualisiere die Position der Kamera basierend auf xrPosition
              // camera.position.setFromMatrixPosition(xrPosition);

              // camera.updateProjectionMatrix();

              final transformProperty = getProperty(views[0], 'transform');
              final matrix = getProperty(transformProperty, 'matrix');

              // Use the view's transform matrix and projection matrix to configure the THREE.camera.
              callMethod(camera.matrix, 'fromArray', [matrix]);

              callMethod(camera.projectionMatrix, 'fromArray',
                  [views[0].projectionMatrix]);

              camera.updateMatrixWorld(true);

              render();
            }
          })
        ]);
      }

      startFrameHandler();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return Expanded(
    //   child: HtmlElementView(viewType: createdViewId),
    // );
  }
}
