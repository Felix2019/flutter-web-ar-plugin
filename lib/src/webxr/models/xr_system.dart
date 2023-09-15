class XRSystem {
  void test() {
    FlutterWebXr().requestSession().then(allowInterop((session) async {
      setState(() => xrSession = session);

      gl = rendererController.glObject;

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
            startFrameHandler();

            // Bind the graphics framebuffer to the baseLayer's framebuffer.
            final renderState = getProperty(session, 'renderState');
            final baseLayer = getProperty(renderState, 'baseLayer');
            final framebuffer = getProperty(baseLayer, 'framebuffer');

            final num glFramebuffer = getProperty(gl!, "FRAMEBUFFER");
            callMethod(gl!, 'bindFramebuffer', [glFramebuffer, framebuffer]);

            // Retrieve the pose of the device.
            // XRFrame.getViewerPose can return null while the session attempts to establish tracking.
            final pose =
                callMethod(xrFrame, 'getViewerPose', [xrReferenceSpace]);

            domLog(pose);

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
              rendererController.setSize(viewportWidth, viewportHeight);

              // Aktualisiere die Position der Kamera basierend auf xrPosition
              // camera.position.setFromMatrixPosition(xrPosition);

              // camera.updateProjectionMatrix();

              final transformProperty = getProperty(views[0], 'transform');
              final matrix = getProperty(transformProperty, 'matrix');

              // Use the view's transform matrix and projection matrix to configure the THREE.camera.
              final camera = cameraController.cameraInstance;
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
}
