import 'dart:js_util';

import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/webxr/interop/core.dart';
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
  final CameraController cameraController = CameraController();
  final SceneController sceneController = SceneController();

  Future<bool> isSessionSupported() async {
    try {
      multiplyObject();
      return await promiseToFuture(
          xrSystem!.isSessionSupported('immersive-ar'));
    } catch (e) {
      throw Exception('Error checking session support: $e');
    }
  }

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
    callMethod(xrSession, 'updateRenderState', [renderStateInit]);
  }

  // request the reference space
  Future<void> requestReferenceSpace() async {
    const xrReferenceSpaceType = 'local';

    xrReferenceSpace = await promiseToFuture(
        xrSession.requestReferenceSpace(xrReferenceSpaceType));

    // xrReferenceSpace = await promiseToFuture(
    //     callMethod(xrSession, 'requestReferenceSpace', [xrReferenceSpaceType]));
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

    try {
      xrSession =
          await promiseToFuture(xrSystem!.requestSession("immersive-ar"));

      setupXRSession(xrSession);
    } catch (e) {
      throw Exception('Error requesting session: $e');
    }
  }

  // Bind the graphics framebuffer to the baseLayer's framebuffer.
  void bindGraphicsFramebuffer(XRSession xrSession, Object? gl) {
    // Get the framebuffer property from the baseLayer
    final framebuffer = xrSession.renderState.baseLayer.framebuffer;

    // Get the FRAMEBUFFER constant from the gl object
    final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");

    // Bind the framebuffer using the WebGL method
    callMethod(gl, 'bindFramebuffer', [glFramebuffer, framebuffer]);
  }

  // register XR-Frame-Handler
  void startFrameHandler() {
    callMethod(xrSession, 'requestAnimationFrame', [
      allowInterop((time, xrFrame) {
        startFrameHandler();

        bindGraphicsFramebuffer(xrSession, gl);

        // Retrieve the pose of the device.
        // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
        final pose = callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

        if (pose != null) {
          // In mobile AR, we only have one view.
          final views = getProperty(pose, 'views');
          return;

          final viewport = callMethod(baseLayer, 'getViewport', [views[0]]);

          final viewportWidth = getProperty(viewport, 'width');
          final viewportHeight = getProperty(viewport, 'height');
          rendererController.setSize(viewportWidth, viewportHeight);

          final transformProperty = getProperty(views[0], 'transform');
          final matrix = getProperty(transformProperty, 'matrix');

          // Use the view's transform matrix and projection matrix to configure the THREE.camera.
          final camera = cameraController.cameraInstance;
          callMethod(camera.matrix, 'fromArray', [matrix]);

          callMethod(camera.projectionMatrix, 'fromArray',
              [views[0].projectionMatrix]);

          camera.updateMatrixWorld(true);

          rendererController.render(
              sceneController.scene, cameraController.cameraInstance);
        }
      })
    ]);
  }

  void test() {
    FlutterWebXr().requestSession().then(allowInterop((session) async {
      // setState(() => xrSession = session);

      gl = rendererController.glObject;

      final xrLayer = XRWebGLLayer(session, gl);

      // Create a XRRenderStateInit object with xrLayer as the baseLayer
      final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

      // Pass the XRRenderStateInit object to updateRenderState
      callMethod(session, 'updateRenderState', [renderStateInit]);

      // request the reference space
      requestReferenceSpace();
      // const xrReferenceSpaceType = 'local';
      // var xrReferenceSpace = await promiseToFuture(
      //     callMethod(session, 'requestReferenceSpace', [xrReferenceSpaceType]));

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

            // Retrieve the pose of the device.
            // XRFrame.getViewerPose can return null while the session attempts to establish tracking.

            // return;
            // final pose =
            //     callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

            // if (pose != null) {
            //   // final xrTransform = pose.transform;
            //   // final xrPosition = xrTransform.position;
            //   // final xrOrientation = xrTransform.orientation;

            //   // camera.position.x = xrPosition.x;
            //   // camera.position.y = xrPosition.y;
            //   // camera.position.z = xrPosition.z;

            //   // In mobile AR, we only have one view.
            //   final views = getProperty(pose, 'views');

            //   final viewport = callMethod(baseLayer, 'getViewport', [views[0]]);

            //   final viewportWidth = getProperty(viewport, 'width');
            //   final viewportHeight = getProperty(viewport, 'height');
            //   rendererController.setSize(viewportWidth, viewportHeight);

            //   // Aktualisiere die Position der Kamera basierend auf xrPosition
            //   // camera.position.setFromMatrixPosition(xrPosition);

            //   // camera.updateProjectionMatrix();

            //   final transformProperty = getProperty(views[0], 'transform');
            //   final matrix = getProperty(transformProperty, 'matrix');

            //   // Use the view's transform matrix and projection matrix to configure the THREE.camera.
            //   final camera = cameraController.cameraInstance;
            //   callMethod(camera.matrix, 'fromArray', [matrix]);

            //   callMethod(camera.projectionMatrix, 'fromArray',
            //       [views[0].projectionMatrix]);

            //   camera.updateMatrixWorld(true);

            //   // render();
            // }
          })
        ]);
      }

      startFrameHandler();
    }));
  }
}
