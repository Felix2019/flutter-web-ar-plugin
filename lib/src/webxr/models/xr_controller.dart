import 'dart:html' as html;
import 'dart:js_interop_unsafe';
import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_frame.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_web_gl_layer.dart';
import 'package:flutter_web_xr/utils.dart';

class XRController {
  late Object? gl;
  late XRSession xrSession;
  late XRReferenceSpace xrReferenceSpace;
  late XRWebGLLayer baseLayer;

  final RendererController rendererController = RendererController.create();
  // final CameraController cameraController = CameraController();
  // final SceneController sceneController = SceneController();

  SceneController get sceneController => rendererController.sceneController;

  XRController() {
    domLog("create xr controller");
  }

  void addElement() {
    // final BoxGeometry geometry = BoxGeometry(1, 1, 1);
    final BoxGeometry geometry = BoxGeometry(0.2, 0.2, 0.2);

    final materials = [
      MeshBasicMaterial(jsify({'color': 0xff0000})),
      MeshBasicMaterial(jsify({'color': 0x0000ff})),
      MeshBasicMaterial(jsify({'color': 0x00ff00})),
      MeshBasicMaterial(jsify({'color': 0xff00ff})),
      MeshBasicMaterial(jsify({'color': 0x00ffff})),
      MeshBasicMaterial(jsify({'color': 0xffff00}))
    ];

    final Mesh object = Mesh(geometry, materials);
    object.position.x = 0;
    object.position.y = 0;
    object.position.z = -1;

    object.rotation.x += 7;
    object.rotation.y += 7;

    sceneController.addElement(object);
  }

  Future<bool> isSessionSupported() async {
    try {
      // multiplyObject();
      addElement();
      return await promiseToFuture(
          xrSystem!.isSessionSupported('immersive-ar'));
    } catch (e) {
      throw Exception('Error checking session support: $e');
    }
  }

  final geometry = BoxGeometry(0.2, 0.2, 0.2);
  late Mesh? cube;

  final materials = [
    MeshBasicMaterial(jsify({'color': 0xff0000})),
    MeshBasicMaterial(jsify({'color': 0x0000ff})),
    MeshBasicMaterial(jsify({'color': 0x00ff00})),
    MeshBasicMaterial(jsify({'color': 0xff00ff})),
    MeshBasicMaterial(jsify({'color': 0x00ffff})),
    MeshBasicMaterial(jsify({'color': 0xffff00}))
  ];

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

  //  void render() {
  //   final List<Mesh> activeObjects = sceneController.activeObjects;

  //   for (var i = 0; i < activeObjects.length; i++) {
  //     final Mesh object = activeObjects[i];
  //     meshController.rotateObject(object, xValue: 0.03, yValue: 0.03);
  //   }

  //   rendererController.render(
  //       sceneController.scene, cameraController.perspectiveCamera);
  // }

  void initializeGL() {
    gl = rendererController.glObject;
  }

  XRWebGLLayer createXRWebGLLayer(XRSession xrSession) {
    return XRWebGLLayer(xrSession, gl);
  }

  // Create a XRRenderStateInit object with xrLayer as the baseLayer
  XRRenderStateInit createXRRenderStateInit(XRWebGLLayer xrLayer) {
    return XRRenderStateInit(baseLayer: xrLayer);
  }

  // Pass the XRRenderStateInit object to updateRenderState
  void updateRenderState(
      XRSession xrSession, XRRenderStateInit renderStateInit) {
    xrSession.updateRenderState(renderStateInit);
  }

  // request the reference space
  Future<void> requestReferenceSpace() async {
    const xrReferenceSpaceType = 'local';

    xrReferenceSpace = await promiseToFuture(
        xrSession.requestReferenceSpace(xrReferenceSpaceType));
  }

  void setupXRSession(XRSession xrSession) {
    initializeGL();
    XRWebGLLayer xrLayer = createXRWebGLLayer(xrSession);
    XRRenderStateInit renderStateInit = createXRRenderStateInit(xrLayer);
    updateRenderState(xrSession, renderStateInit);
    requestReferenceSpace();
  }

  Future<void> requestSession() async {
    if (!(await isSessionSupported())) {
      throw Exception('WebXR Session not supported');
    }

    html.DivElement overlay = html.DivElement()
      ..id = 'ar-overlay'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      ..style.width = '10%'
      ..style.height = '10%'
      ..style.zIndex = '100000'
      ..style.backgroundColor = "green"
      ..innerText = 'Hier ist das AR DOM Overlay!';

    html.document.body!.children.add(overlay);

    var options = {
      'optionalFeatures': ['dom-overlay'],
      'domOverlay': {'root': html.document.getElementById('ar-overlay')}
    };

    domLog(jsify(options));

    try {
      xrSession = await promiseToFuture(
          xrSystem!.requestSession("immersive-ar", jsify(options)));

//           let uiElement = document.getElementById('ui');
// navigator.xr.requestSession('immersive-ar', {
//     optionalFeatures: ['dom-overlay'],
//     domOverlay: { root: uiElement } }).then((session) => {
//     // session.domOverlayState.type is now set if supported,
//     // or is null if the feature is not supported.
//   }
// }

      domLog(xrSession.domOverlayState);

      setupXRSession(xrSession);

      // domLog("xr controller");
      // domLog(rendererController.sceneController.activeObjects);
    } catch (e) {
      throw Exception('Error requesting session: $e');
    }
  }

  Future<void> endSession() async {
    await xrSession.end();
  }

  void startFrameHandler() {
    xrSession.requestAnimationFrame(allowInterop(frameHandler));
  }

  void frameHandler(double time, XRFrame xrFrame) {
    startFrameHandler();
    bindGraphicsFramebuffer(xrSession, gl);

    final XRViewerPose? pose = getViewerPose(xrFrame);
    if (pose != null) {
      // In mobile AR, we only have one view.
      configureRendererForView(pose.views[0]);
    }
  }

  // Bind the graphics framebuffer to the baseLayer's framebuffer.
  void bindGraphicsFramebuffer(XRSession xrSession, Object? gl) {
    // Get the baseLayer from the xrSession
    baseLayer = xrSession.renderState.baseLayer;

    // Get the framebuffer property from the baseLayer
    final framebuffer = xrSession.renderState.baseLayer.framebuffer;

    // Get the FRAMEBUFFER constant from the gl object
    final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");

    // Bind the framebuffer using the WebGL method
    callMethod(gl, 'bindFramebuffer', [glFramebuffer, framebuffer]);
  }

  // Retrieve the pose of the device.
  XRViewerPose? getViewerPose(XRFrame xrFrame) {
    return xrFrame.getViewerPose(xrReferenceSpace);
  }

  void configureRendererForView(XRFrame view) {
    XRViewport viewport = baseLayer.getViewport(view);
    rendererController.setSize(viewport.width, viewport.height);
    // rendererController.setSize(window.innerWidth!, window.innerHeight!);

    configureCameraForView(view);

    rendererController.render();
  }

  void configureCameraForView(XRFrame view) {
    XRRigidTransform transformProperty = view.transform;
    List<double> matrix = transformProperty.matrix;

    // Use the view's transform matrix and projection matrix to configure the THREE.camera.
    // var camera = cameraController.perspectiveCamera;
    var camera = rendererController.cameraController.perspectiveCamera;
    callMethod(camera.matrix, 'fromArray', [matrix]);
    callMethod(camera.projectionMatrix, 'fromArray', [view.projectionMatrix]);
    camera.updateMatrixWorld(true);
  }

  // register XR-Frame-Handler
  // void startFrameHandler() {
  //   xrSession
  //       .requestAnimationFrame(allowInterop((double time, XRFrame xrFrame) {
  //     startFrameHandler();

  //     bindGraphicsFramebuffer(xrSession, gl);

  //     // Retrieve the pose of the device.
  //     // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
  //     final XRViewerPose? pose = xrFrame.getViewerPose(xrReferenceSpace);

  //     if (pose != null) {
  //       final List views = pose.views;
  //       // In mobile AR, we only have one view.
  //       final XRFrame view = views[0];

  //       final XRViewport viewport = baseLayer.getViewport(view);
  //       rendererController.setSize(viewport.width, viewport.height);

  //       final XRRigidTransform transformProperty = view.transform;

  //       final List<double> matrix = transformProperty.matrix;

  //       // Use the view's transform matrix and projection matrix to configure the THREE.camera.
  //       final camera = cameraController.perspectiveCamera;
  //       callMethod(camera.matrix, 'fromArray', [matrix]);

  //       callMethod(
  //           camera.projectionMatrix, 'fromArray', [view.projectionMatrix]);

  //       camera.updateMatrixWorld(true);

  //       rendererController.render(sceneController.scene, camera);
  //     }
  //   }));
  // }

  // void test() {
  //   FlutterWebXr().requestSession().then(allowInterop((session) async {
  //     setState(() => xrSession = session);

  //     gl = rendererController.glObject;

  //     final xrLayer = XRWebGLLayer(session, gl);

  //     // Create a XRRenderStateInit object with xrLayer as the baseLayer
  //     final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

  //     // Pass the XRRenderStateInit object to updateRenderState
  //     callMethod(session, 'updateRenderState', [renderStateInit]);

  //     // request the reference space
  //     requestReferenceSpace();
  //     // const xrReferenceSpaceType = 'local';
  //     // var xrReferenceSpace = await promiseToFuture(
  //     //     callMethod(session, 'requestReferenceSpace', [xrReferenceSpaceType]));

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

  //             // render();
  //           }
  //         })
  //       ]);
  //     }

  //     startFrameHandler();
  //   }));
  // }
}
