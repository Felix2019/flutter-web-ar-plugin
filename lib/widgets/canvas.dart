import 'dart:html';
import 'dart:js_util';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_render_state.dart';
import 'package:flutter_web_xr/src/webxr/interop/xr_web_gl_layer.dart';
import 'package:flutter_web_xr/utils.dart';
import 'package:three_dart/three_dart.dart' as three;

import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class MyCanvas extends StatefulWidget {
  const MyCanvas({super.key});

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  final html.CanvasElement canvas = CanvasElement()
    ..style.backgroundColor = 'blue'
    ..style.width = '100%'
    ..style.height = '100%';

  String createdViewId = 'webgl_canvas';
  late Object? gl;
  late Object? xrSession;

  // three js variables
  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  late double width;
  late double height;
  Size? screenSize;

  late three.Scene scene;
  late three.Camera camera;
  late three.Mesh cube;

  double devicePixelRatio = 1.0;
  bool verbose = true;
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    registerCanvas();
    // startXRSession();
    // html.document.body!.append(canvas);

    // initSize(context);

    // var sessionInit = XRSessionInit(immersiveAr: true);
    // navigatorXr.requestSession('immersive-ar', sessionInit).then((session) {
    //   var xrLayer = XRWebGLLayer(session, gl);
    //   session.updateRenderState(XRRenderStateInit(baseLayer: xrLayer));
    // });
  }

  @override
  void dispose() {
    disposed = true;
    three3dRender.dispose();

    super.dispose();
  }

  void registerCanvas() {
    // Ensure the canvas is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory('webgl_canvas', (int viewId) => canvas);

    // create a webgl context
    gl = canvas.getContext('webgl', {'xrCompatible': true});

    print("register canvas");
    domLog("gl: $gl");
  }

  // void startXRSession() {
  //   // var sessionInit = XRSessionInit(immersiveAr: true); as option parameter in requestSession
  //   FlutterWebXr().startSession().then(allowInterop((session) async {
  //     setState(() => xrSession = session);

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
  //           // initSize(context);
  //           // test1(xrFrame);
  //           // render();
  //           startFrameHandler();
  //         })
  //       ]);
  //     }

  //     startFrameHandler();
  //   }));

  //   // initPlatformState();
  // }

  // second function to be called
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(context) async {
    if (screenSize != null) {
      return;
    }

    final mqd = MediaQuery.of(context);
    screenSize = mqd.size;
    devicePixelRatio = mqd.devicePixelRatio;

    width = screenSize!.width;
    height = screenSize!.height;

    three3dRender = FlutterGlPlugin();

    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": devicePixelRatio
    };

    await three3dRender.initialize(options: options);
    setState(() {});

    Future.delayed(const Duration(milliseconds: 100), () async {
      // await three3dRender.prepareContext();
      initScene();
    });
  }

  // third function to be called
  initScene() {
    initRenderer();
    initPage();
  }

  // fourth function to be called
  initRenderer() {
    print("init renderer");
    domLog(gl!);

    // print("renderer ready");

    Map<String, dynamic> options = {
      "width": 200,
      "height": 200,
      "gl": three3dRender.gl,
      // "gl": gl!,
      "antialias": true,
      "canvas": three3dRender.element
      // "canvas": canvas
    };

    renderer = three.WebGLRenderer(options);
    // test1(renderer);
    renderer!.setPixelRatio(devicePixelRatio);
    renderer!.setSize(width, height, false);
    // renderer!.setSize(html.window.innerWidth,
    //     html.window.innerHeight!.toDouble(), false);

    // ! test
    // html.document.body!.append(renderer!.domElement);
    // renderer!.shadowMap.enabled = false;
  }

  initPage() async {
    // camera = three.PerspectiveCamera(45, width / height, 1, 2000);
    camera = three.PerspectiveCamera(75, width / height, 0.1, 1000);
    // camera.position.z = 5;
    camera.position.z = 250;

    scene = three.Scene();

    var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    scene.add(ambientLight);

    var pointLight = three.PointLight(0xffffff, 0.8);
    camera.add(pointLight);
    scene.add(camera);

    // create a cube
    final geometry = three.BoxGeometry(75, 75, 75);
    final material = three.MeshBasicMaterial({"color": 0x00ff00});
    cube = three.Mesh(geometry, material);
    scene.add(cube);

    animate();
  }

  animate() {
    if (!mounted || disposed) {
      return;
    }

    // cube.rotation.x += 0.07;
    // cube.rotation.y += 0.07;
    render();

    Future.delayed(const Duration(milliseconds: 40), () {
      animate();
    });
  }

  render() {
    print("render");

    final gl = three3dRender.gl;

    renderer!.render(scene, camera);

    gl.flush();

    // Future.delayed(const Duration(seconds: 2), () {
    //   print("render delay");

    //   renderer!.render(scene, camera);
    //   // callMethod(xrSession!, 'requestAnimationFrame', [
    //   //   allowInterop((time, xrFrame) {
    //   //     if (renderer != null) {
    //   //       print("not null");
    //   //       renderer!.render(scene, camera);
    //   //     }
    //   //   })
    //   // ]);
    // });

    // renderer!.render(scene, camera);
    // callMethod(xrSession!, 'requestAnimationFrame', [allowInterop(render)]);

    // callMethod(xrSession!, 'requestAnimationFrame', [
    //   allowInterop((time, xrFrame) {
    //     if (renderer != null) {
    //       renderer!.render(scene, camera);
    //     }
    //   }),
    // ]);
    // }

    // final gl = three3dRender.gl;
    // renderer!.render(scene, camera);
    // callMethod(xrSession!, 'requestAnimationFrame', [allowInterop(render)]);
    // html.window.requestAnimationFrame(render());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        color: Colors.green,
        child: Builder(
          builder: (BuildContext context) {
            // initPlatformState(context);

            // print(three3dRender.isInitialized);

            return Container();

            // return three3dRender.isInitialized
            //     ? HtmlElementView(viewType: three3dRender.textureId!.toString())
            //     : const SizedBox.shrink();

            // return HtmlElementView(
            //   // viewType: createdViewId,
            //   viewType: three3dRender.textureId!.toString(),
            //   // onPlatformViewCreated: (int viewId) {
            //   //   // check if canvas is ready
            //   //   if (canvas != null) {
            //   //     // ignore: undefined_prefixed_name
            //   //     ui.platformViewRegistry.registerViewFactory(
            //   //       'webgl_canvas',
            //   //       (int viewId) => canvas,
            //   //     );
            //   //   }
            //   // }
            // );
          },
        ));
  }
}
