import 'dart:html' as html;
import 'dart:js_util';

import 'package:flutter_web_xr/src/threejs/interop/mesh.dart';
import 'package:flutter_web_xr/src/threejs/interop/rendering.dart';
import 'package:flutter_web_xr/src/threejs/interop/transformations.dart';
import 'package:flutter_web_xr/src/threejs/models/camera_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/renderer_controller.dart';
import 'package:flutter_web_xr/src/threejs/models/scene_controller.dart';
import 'package:flutter_web_xr/src/webxr/interop/core.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_frame.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_session.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_web_gl_layer.dart';

class XRController {
  final RendererController rendererController;
  final SceneController sceneController;
  final CameraController cameraController;

  late Object? gl;
  late XRSession xrSession;
  late XRReferenceSpace xrReferenceSpace;
  late XRWebGLLayer baseLayer;

  XRController(
      this.rendererController, this.sceneController, this.cameraController);

  bool isWebXrSupported() => xrSystem != null;

  Future<bool> isSessionSupported() async {
    try {
      return await promiseToFuture(
          xrSystem!.isSessionSupported('immersive-ar'));
    } catch (e) {
      throw Exception('Error checking session support: $e');
    }
  }

  Map<String, dynamic> setupXrDomOverlay() {
    // main container
    html.DivElement xrOverlay = html.DivElement()..id = 'xr-overlay';

    // Overlay 1
    html.DivElement overlay = html.DivElement()
      ..id = 'ar-overlay'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0'
      // ..style.width = '25%'
      // ..style.height = '50px'
      ..style.zIndex = '10000'
      ..style.backgroundColor = "green"
      ..innerText = 'Hier ist das AR DOM Overlay!';

    xrOverlay.children.add(overlay);

    html.ButtonElement closeButton = html.ButtonElement()
      ..id = 'close-button'
      ..style.position = 'absolute'
      ..style.top = '15px'
      ..style.right = '15px'
      ..style.zIndex = '10000'
      ..style.padding = '6px'
      ..style.backgroundColor = "white"
      ..style.borderRadius = '12px'
      ..style.borderColor = "transparent"
      ..innerText = 'Close Session';

    xrOverlay.children.add(closeButton);

    // add main container to document body
    html.document.body?.children.add(xrOverlay);

    closeButton.onClick.listen((event) {
      endSession();
      closeButton.remove();
      overlay.remove();
    });

    overlay.onClick.listen((event) {
      // addElement1();
      // rendererController.render();
    });

    return {
      'optionalFeatures': ['dom-overlay'],
      'domOverlay': {
        'root': html.document.getElementById('ar-overlay'),
      }
    };
  }

  Future<void> requestSession() async {
    if (!(await isSessionSupported())) {
      throw Exception('WebXR Session not supported');
    }

    final Map<String, dynamic> sessionOptions = setupXrDomOverlay();

    try {
      xrSession = await promiseToFuture(
          xrSystem!.requestSession("immersive-ar", jsify(sessionOptions)));

      await setupXRSession();
    } catch (e) {
      throw Exception('Error requesting session: $e');
    }
  }

  Future<void> endSession() async {
    await xrSession.end();
  }

  Future<void> setupXRSession() async {
    initializeGL();
    XRWebGLLayer xrLayer = createXRWebGLLayer();
    XRRenderStateInit renderStateInit = createXRRenderStateInit(xrLayer);
    updateRenderState(renderStateInit);
    await requestReferenceSpace();
  }

  void initializeGL() {
    gl = rendererController.glObject;
  }

  XRWebGLLayer createXRWebGLLayer() {
    return XRWebGLLayer(xrSession, gl);
  }

  // Create a XRRenderStateInit object with xrLayer as the baseLayer
  XRRenderStateInit createXRRenderStateInit(XRWebGLLayer xrLayer) {
    return XRRenderStateInit(baseLayer: xrLayer);
  }

  // Pass the XRRenderStateInit object to updateRenderState
  void updateRenderState(XRRenderStateInit renderStateInit) {
    xrSession.updateRenderState(renderStateInit);
  }

  // request the reference space
  Future<void> requestReferenceSpace() async {
    const xrReferenceSpaceType = 'local';

    xrReferenceSpace = await promiseToFuture(
        xrSession.requestReferenceSpace(xrReferenceSpaceType));
  }

  void startFrameHandler() {
    xrSession.requestAnimationFrame(allowInterop(frameHandler));
  }

  void frameHandler(double time, XRFrame xrFrame) {
    startFrameHandler();
    bindGraphicsFramebuffer();

    final XRViewerPose? pose = getViewerPose(xrFrame);

    if (pose != null) {
      // In mobile AR, we only have one view.
      configureRendererForView(pose.views[0]);
    }
  }

  // Bind the graphics framebuffer to the baseLayer's framebuffer.
  void bindGraphicsFramebuffer() {
    // Get the baseLayer from the xrSession
    baseLayer = xrSession.renderState.baseLayer;

    // Get the framebuffer property from the baseLayer
    final framebuffer = xrSession.renderState.baseLayer.framebuffer;

    // Get the FRAMEBUFFER constant from the gl object
    final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");

    // Bind the framebuffer using the WebGL method
    callMethod(gl!, 'bindFramebuffer', [glFramebuffer, framebuffer]);
  }

  // Retrieve the pose of the device.
  XRViewerPose? getViewerPose(XRFrame xrFrame) {
    return xrFrame.getViewerPose(xrReferenceSpace);
  }

  void configureRendererForView(XRFrame view) {
    XRViewport viewport = baseLayer.getViewport(view);
    rendererController.setSize(viewport.width, viewport.height);

    configureCameraForView(view);

    rendererController.render(
        sceneController.scene, cameraController.perspectiveCamera);
  }

  void configureCameraForView(XRFrame view) {
    List<double> matrix = view.transform.matrix;
    List<double> projectionMatrix = view.projectionMatrix;

    // Use the view's transform matrix and projection matrix to configure the THREE.camera.
    final PerspectiveCamera camera = cameraController.perspectiveCamera;

    camera.matrix.fromArray(matrix);
    camera.projectionMatrix.fromArray(projectionMatrix);
    camera.updateMatrixWorld(true);
  }
}
