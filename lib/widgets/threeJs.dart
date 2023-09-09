import 'package:flutter/material.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;

class WebglMaterialsBrowser extends StatefulWidget {
  final String fileName;

  const WebglMaterialsBrowser({Key? key, required this.fileName})
      : super(key: key);

  @override
  State<WebglMaterialsBrowser> createState() => _MyAppState();
}

class _MyAppState extends State<WebglMaterialsBrowser> {
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

  dynamic sourceTexture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    three3dRender.dispose();

    super.dispose();
  }

  // first function to be called
  initSize(BuildContext context) {
    if (screenSize != null) {
      return;
    }

    final mqd = MediaQuery.of(context);
    screenSize = mqd.size;
    devicePixelRatio = mqd.devicePixelRatio;

    initPlatformState();
  }

  // second function to be called
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
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
      await three3dRender.prepareContext();
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
    Map<String, dynamic> options = {
      "width": width,
      "height": height,
      "gl": three3dRender.openGL,
      "antialias": true,
      "canvas": three3dRender.element
    };
    renderer = three.WebGLRenderer(options);
    renderer!.setPixelRatio(devicePixelRatio);
    renderer!.setSize(width, height, false);
    renderer!.shadowMap.enabled = false;
  }

  initPage() async {
    camera = three.PerspectiveCamera(75, width / height, 0.1, 1000);
    camera.position.z = 250;
    scene = three.Scene();

    var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    scene.add(ambientLight);

    var pointLight = three.PointLight(0xffffff, 0.8);
    camera.add(pointLight);
    scene.add(camera);

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

    cube.rotation.x += 0.07;
    cube.rotation.y += 0.07;

    render();

    Future.delayed(const Duration(milliseconds: 40), () {
      animate();
    });
  }

  render() {
    int t = DateTime.now().millisecondsSinceEpoch;

    final gl = three3dRender.gl;
    renderer!.render(scene, camera);

    int t1 = DateTime.now().millisecondsSinceEpoch;

    if (verbose) {
      print("render cost: ${t1 - t} ");
      print(renderer!.info.memory);
      print(renderer!.info.render);
    }

    gl.flush();
    if (verbose) print(" render: sourceTexture: $sourceTexture ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Builder(
        builder: (BuildContext context) {
          initSize(context);
          return SingleChildScrollView(child: _build(context));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("render"),
        onPressed: () {
          render();
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                width: width,
                height: height,
                color: Colors.white,
                child: Builder(builder: (BuildContext context) {
                  return three3dRender.isInitialized
                      ? HtmlElementView(
                          viewType: three3dRender.textureId!.toString())
                      : const SizedBox.shrink();
                })),
          ],
        ),
      ],
    );
  }
}
