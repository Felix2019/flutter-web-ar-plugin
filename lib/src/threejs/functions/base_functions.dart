// import 'dart:js_util';
// import 'dart:ui' as ui;
// import 'dart:html' as html;

// // abstract class Renderer {
// //     void renderObject(Object3D obj);
// // }


// class BaseFunctions {

//    final html.CanvasElement canvas = html.CanvasElement()
//     ..style.width = '100%'
//     ..style.height = '100%';

//   late Object? gl;


// void registerCanvas(String createdViewId) {
//   // Register div as a view and ensure the div is ready before we try to use it
//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry
//       .registerViewFactory(createdViewId, (int viewId) => canvas);
// }

// void initRenderer() async {
//   gl = canvas.getContext('webgl', {'xrCompatible': true});

//   final Object options = jsify({
//     'context': gl,
//     'canvas': canvas,
//     'alpha': true,
//     'preserveDrawingBuffer': true,
//   });

//   renderer = WebGLRenderer(options);
//   renderer.autoClear = false;
//   renderer.xr.enabled = true;
// }
