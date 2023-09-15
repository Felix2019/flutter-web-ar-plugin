import 'dart:js_util';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/mesh_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_web_gl_layer.dart';
import 'package:flutter_web_xr/utils.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter/material.dart';

class MyCanvasTest extends StatefulWidget {
  const MyCanvasTest({super.key});

  @override
  State<MyCanvasTest> createState() => _MyCanvasTestState();
}

class _MyCanvasTestState extends State<MyCanvasTest> {
  late RendererController rendererController;
  late SceneController sceneController;
  late CameraController cameraController;
  late MeshController meshController;

  late Object? gl;
  late Object? xrSession;

  final geometry = BoxGeometry(0.2, 0.2, 0.2);
  late Mesh? cube;

  List<Mesh> activeObjects = [];

  final materials = [
    MeshBasicMaterial(jsify({'color': 0xff0000})),
    MeshBasicMaterial(jsify({'color': 0x0000ff})),
    MeshBasicMaterial(jsify({'color': 0x00ff00})),
    MeshBasicMaterial(jsify({'color': 0xff00ff})),
    MeshBasicMaterial(jsify({'color': 0x00ffff})),
    MeshBasicMaterial(jsify({'color': 0xffff00}))
  ];

  @override
  void initState() {
    super.initState();

    rendererController = RendererController.create();
    sceneController = SceneController();
    cameraController = CameraController();
    meshController = MeshController();

    cube = Mesh(geometry, materials);
    multiplyObject();

    startXRSession();
  }

  void multiplyObject() {
    const rowCount = 4;
    const half = rowCount / 2;

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < rowCount; j++) {
        for (var k = 0; k < rowCount; k++) {
          final Mesh object = Mesh(geometry, materials);

          object.position.x = i - half;
          object.position.y = j - half;
          object.position.z = k - half;

          object.rotation.x += 7;
          object.rotation.y += 7;

          sceneController.addElement(object);
        }
      }
    }
  }

  void render() {
    final List<Mesh> activeObjects = sceneController.activeObjects;

    for (var i = 0; i < activeObjects.length; i++) {
      final Mesh object = activeObjects[i];
      meshController.rotateObject(object, xValue: 0.03, yValue: 0.03);
    }

    rendererController.render(
        sceneController.scene, cameraController.cameraInstance);
  }

  void startXRSession() {
    var sessionInit = XRSessionInit(immersiveAr: true);

    domLog(sessionInit);

    // void startXRSession() {
    //   // var sessionInit = XRSessionInit(immersiveAr: true); as option parameter in requestSession
    //   FlutterWebXr().requestSession().then(allowInterop((session) async {
    //     setState(() => xrSession = session);

    //     gl = rendererController.glObject;

    //     final xrLayer = XRWebGLLayer(session, gl);

    //     // Create a XRRenderStateInit object with xrLayer as the baseLayer
    //     final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

    //     // Pass the XRRenderStateInit object to updateRenderState
    //     callMethod(session, 'updateRenderState', [renderStateInit]);

    //     // request the reference space
    //     const xrReferenceSpaceType = 'local';
    //     var xrReferenceSpace = await promiseToFuture(
    //         callMethod(session, 'requestReferenceSpace', [xrReferenceSpaceType]));

    //     // register XR-Frame-Handler
    //     startFrameHandler() {
    //       callMethod(session, 'requestAnimationFrame', [
    //         allowInterop((time, xrFrame) {
    //           startFrameHandler();

    //           // Bind the graphics framebuffer to the baseLayer's framebuffer.
    //           final renderState = getProperty(session, 'renderState');
    //           final baseLayer = getProperty(renderState, 'baseLayer');
    //           final framebuffer = getProperty(baseLayer, 'framebuffer');

    //           final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");
    //           callMethod(gl!, 'bindFramebuffer', [glFramebuffer, framebuffer]);

    //           // Retrieve the pose of the device.
    //           // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
    //           final pose =
    //               callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

    //           domLog(pose);

    //           if (pose != null) {
    //             // final xrTransform = pose.transform;
    //             // final xrPosition = xrTransform.position;
    //             // final xrOrientation = xrTransform.orientation;

    //             // camera.position.x = xrPosition.x;
    //             // camera.position.y = xrPosition.y;
    //             // camera.position.z = xrPosition.z;

    //             // In mobile AR, we only have one view.
    //             final views = getProperty(pose, 'views');

    //             final viewport = callMethod(baseLayer, 'getViewport', [views[0]]);

    //             final viewportWidth = getProperty(viewport, 'width');
    //             final viewportHeight = getProperty(viewport, 'height');
    //             rendererController.setSize(viewportWidth, viewportHeight);

    //             // Aktualisiere die Position der Kamera basierend auf xrPosition
    //             // camera.position.setFromMatrixPosition(xrPosition);

    //             // camera.updateProjectionMatrix();

    //             final transformProperty = getProperty(views[0], 'transform');
    //             final matrix = getProperty(transformProperty, 'matrix');

    //             // Use the view's transform matrix and projection matrix to configure the THREE.camera.
    //             final camera = cameraController.cameraInstance;
    //             callMethod(camera.matrix, 'fromArray', [matrix]);

    //             callMethod(camera.projectionMatrix, 'fromArray',
    //                 [views[0].projectionMatrix]);

    //             camera.updateMatrixWorld(true);

    //             render();
    //           }
    //         })
    //       ]);
    //     }

    //     startFrameHandler();
    //   }));
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return Expanded(
    //   child: HtmlElementView(viewType: createdViewId),
    // );
  }
}
