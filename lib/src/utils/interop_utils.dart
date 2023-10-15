import 'dart:js_util';
import 'package:js/js.dart';

Map<String, dynamic> objectToMap(jsObject) {
  var map = <String, dynamic>{};
  // var propertyNames = js.context.Object.keys(jsObject);
  // var propertyNames = js.JsObject.getOwnPropertyNames(jsObject);
  // print(propertyNames);

  jsObject.forEach((key, value) {
    print(key);
    // map[key] = getProperty(jsObject, key);
    // print(map[key]);
  });

  //  WebBluetoothDevice.fromJSObject(this._jsObject) {
  if (!hasProperty(jsObject, "id")) {
    throw UnsupportedError("JSObject does not have an id.");
  }
  // }

  print(map);

  // for (var propertyName in propertyNames) {
  //   var propertyValue = jsObject[propertyName];
  //   map[propertyName] =
  //       js.context.hasProperty(propertyValue, '\$dart_js_closure')
  //           ? js.allowInterop(propertyValue)
  //           : propertyValue;
  // }

  return map;
}

// This function will open new popup window for given URL.
@JS()
external dynamic jsOpenTabFunction(String url);

@JS('console.log')
external void domLog(dynamic message);

@JS('JSON.stringify')
external String stringify(Object? obj);

@JS('WebGL2RenderingContext')
@staticInterop
class WebGL2RenderingContext {}




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




// @JS()
// @anonymous
// class MyObject {
//   external num get x;
//   external set x(num value);

//   external num get y;
//   external set y(num value);
// }


//  void startFrameHandler1() async {
//     gl = rendererController.glObject;
//     final xrLayer = XRWebGLLayer(xrSession, gl);

//     // Create a XRRenderStateInit object with xrLayer as the baseLayer
//     final renderStateInit = XRRenderStateInit(baseLayer: xrLayer);

//     // Pass the XRRenderStateInit object to updateRenderState
//     callMethod(xrSession, 'updateRenderState', [renderStateInit]);

//     // request the reference space
//     const xrReferenceSpaceType = 'local';
//     var xrReferenceSpace = await promiseToFuture(
//         callMethod(xrSession, 'requestReferenceSpace', [xrReferenceSpaceType]));

//     callMethod(xrSession, 'requestAnimationFrame', [
//       allowInterop((time, xrFrame) {
//         startFrameHandler1();

//         // Bind the graphics framebuffer to the baseLayer's framebuffer.
//         final renderState = getProperty(xrSession, 'renderState');
//         final baseLayer = getProperty(renderState, 'baseLayer');
//         final framebuffer = getProperty(baseLayer, 'framebuffer');

//         final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");
//         callMethod(gl!, 'bindFramebuffer', [glFramebuffer, framebuffer]);

//         // Retrieve the pose of the device.
//         // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
//         final pose = callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

//         if (pose != null) {
//           // final xrTransform = pose.transform;
//           // final xrPosition = xrTransform.position;
//           // final xrOrientation = xrTransform.orientation;

//           // camera.position.x = xrPosition.x;
//           // camera.position.y = xrPosition.y;
//           // camera.position.z = xrPosition.z;

//           // In mobile AR, we only have one view.
//           final views = getProperty(pose, 'views');

//           final viewport = callMethod(baseLayer, 'getViewport', [views[0]]);

//           final viewportWidth = getProperty(viewport, 'width');
//           final viewportHeight = getProperty(viewport, 'height');

//           rendererController.setSize(viewportWidth, viewportHeight);

//           // Aktualisiere die Position der Kamera basierend auf xrPosition
//           // camera.position.setFromMatrixPosition(xrPosition);

//           // camera.updateProjectionMatrix();

//           final transformProperty = getProperty(views[0], 'transform');
//           final matrix = getProperty(transformProperty, 'matrix');

//           // Use the view's transform matrix and projection matrix to configure the THREE.camera.
//           callMethod(
//               cameraController.perspectiveCamera.matrix, 'fromArray', [matrix]);

//           callMethod(cameraController.perspectiveCamera.projectionMatrix,
//               'fromArray', [views[0].projectionMatrix]);

//           cameraController.perspectiveCamera.updateMatrixWorld(true);

//           // render();
//           rendererController.render(
//               sceneController.scene, cameraController.perspectiveCamera);
//         }
//       })
//     ]);
//   }