import 'dart:html';
import 'dart:js';
import 'dart:js_util';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:flutter_web_xr/test.dart';
import 'package:flutter_web_xr/three_manager.dart';
import 'package:js/js.dart' as js;
import 'package:three_dart/three_dart.dart' as three;

import 'package:flutter/material.dart';
import 'package:flutter_web_xr/flutter_web_xr.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

import '../web_xr_manager.dart';

class MyCanvasTest extends StatefulWidget {
  const MyCanvasTest({super.key});

  @override
  State<MyCanvasTest> createState() => _MyCanvasTestState();
}

class _MyCanvasTestState extends State<MyCanvasTest> {
  // final html.CanvasElement canvas = html.CanvasElement()
  //   ..style.backgroundColor = 'red'
  //   ..style.width = '100%'
  //   ..style.height = '100%';

  late WebGLRenderer nativeRenderer;
  late Scene scene1;
  late PerspectiveCamera camera1;
  late Mesh cube1;

  
  




  String createdViewId = 'webgl_canvas';
  late Object? gl;
  late Object? xrSession;



  @override
  void initState() {
    super.initState();
    registerCanvas();

    Map<String, dynamic> options = {
      "width": 200,
      "height": 200,
      // "gl": three3dRender.gl,
      "gl": gl!,
      "antialias": true,
      // "canvas": three3dRender.element
      // "canvas": canvas
    };

    // test1(options);

    nativeRenderer = WebGLRenderer();

    scene1 = Scene();
    camera1 = PerspectiveCamera(
        75, window.innerWidth! / window.innerHeight!, 0.1, 1000);
    camera1.position.z = 5;


    // callMethod(nativeRenderer, 'setSize', [800, 600]);
    // Setzen Sie die Größe des Renderers auf die Größe des Canvas-Elements
    nativeRenderer.setSize(
        window.innerWidth!.toDouble(), window.innerHeight!.toDouble());

    // Fügen Sie den Renderer zum DOM hinzu
    html.document.body!.append(nativeRenderer.domElement);
    // html.document.body!.append(canvas);

    test1(nativeRenderer);
    test1(nativeRenderer.domElement);
    print(nativeRenderer);


    // renderNative();
    animate1(2);
  }

  void animate1(num time) {
    window.requestAnimationFrame(allowInterop(animate1));

    // Rendere die Szene mit der Kamera
    nativeRenderer.render(scene1, camera1);
  }

  

  void registerCanvas() {
    // Ensure the canvas is ready before we try to use it
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory('webgl_canvas', (int viewId) => canvas);

    // create a webgl context
    gl = canvas.getContext('webgl', {'xrCompatible': true});
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
            // initSize(context);
            // test1(xrFrame);
            // render();
            startFrameHandler();
          })
        ]);
      }

      startFrameHandler();
    }));

    // initPlatformState();
  }

 



 

 

 

  renderNative() {
    print("render");

    // create a cube
    final geometry = BoxGeometry(75, 75, 75);
    final material = MeshBasicMaterial(jsify({'color': 0x00ff00}));

    // final material = three.MeshBasicMaterial({"color": 0x00ff00});
    var cube2 = Mesh(geometry, material);
    callMethod(scene1, 'add', [cube2]);
    // scene1.add(cube2);

    nativeRenderer.render(scene1, camera1);

    Future.delayed(const Duration(milliseconds: 40), () {
      renderNative();
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


   Future<void> _initializeCanvas() async {
    // Lade das Three.js-Skript
    await ui.platformViewRegistry.registerViewFactory(
      'webgl_canvas',
      (int viewId) {
        final html.CanvasElement canvas = html.CanvasElement()
          ..style.width = '100%'
          ..style.height = '100%';

        final scriptElement = html.ScriptElement()
          ..src = 'https://cdnjs.cloudflare.com/ajax/libs/three.js/110/three.min.js'
          ..async = true;

        canvas.context2D.fillStyle = '#000000';
        canvas.context2D.fillRect(0, 0, canvas.width, canvas.height);
        canvas.context2D.fillStyle = '#FFFFFF';
        canvas.context2D.font = '20px sans-serif';
        canvas.context2D.fillText('Loading...', 10, 30);

        final divElement = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%';

        divElement.append(scriptElement);
        divElement.append(canvas);

        return divElement;
      },
    );

    // Lade weitere erforderliche Skripte oder führe andere Initialisierungslogik aus
  }
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

            // return three3dRender.isInitialized
            //     ? HtmlElementView(viewType: three3dRender.textureId!.toString())
            //     : const SizedBox.shrink();



            return FutureBuilder<void>(
      future: _initializeCanvas(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: 300, // Breite des Canvas
            height: 300, // Höhe des Canvas
            child: HtmlElementView(
              viewType: 'webgl_canvas',
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );



            // return HtmlElementView(
            //     viewType: createdViewId,
            //     onPlatformViewCreated: (int viewId) {
            //       // check if canvas is ready
            //       if (canvas != null) {
            //         // ignore: undefined_prefixed_name
            //         ui.platformViewRegistry.registerViewFactory(
            //           'webgl_canvas',
            //           (int viewId) => canvas,
            //         );
            //       }
            //     });
          },
        ));
  }
}
