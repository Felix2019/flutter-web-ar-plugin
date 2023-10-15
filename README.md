# Flutter Web XR Plugin

This plugin is in beta. Use it with caution.

This Flutter plugin enables developers to create augmented reality (AR) experiences in their Flutter web applications. With this plugin, you can integrate interactive AR content such as 3D models, animations, and visual effects into your Flutter web projects.

## Getting Started

Add the Flutter package to your project by running:

 ```bash
  flutter pub add flutter_web_xr
  ```

Add the following Script tags to your index.html file in the flutter web directory to import the Three.js library and the GLTFLoader module:

 ```javascript
   <script type="module" defer>
      import * as THREE from "https://jspm.dev/three";
      import { GLTFLoader } from "https://jspm.dev/three/addons/loaders/GLTFLoader.js";

      window.THREE = THREE;
      window.GLTFLoader = GLTFLoader;
    </script>
  ```

## Usage

To utilize WebXR functionalities within your Flutter application, begin by initializing the FlutterWebXr plugin: final FlutterWebXr _flutterWebXrPlugin = FlutterWebXr();. Subsequently, you'll need to set up the 3D models you intend to use by defining them in the _initializeModels method. For instance, to add a cube, label it 'Cube', then configure its AR session to produce a cube with a 0.2-unit side length, and decide its appearance in the scene by specifying its unique view ID and object attributes. For more intricate models like 'Shiba', label it appropriately, set up the AR session to fetch a GLTF model from 'models/shiba/scene.gltf', and indicate its rendering within the scene using its unique view ID and model path.

 ```dart
final FlutterWebXr _flutterWebXrPlugin = FlutterWebXr();

List<ThreeModel> _initializeModels() {
    return [
      ThreeModel(
        name: 'Cube',
        startARSession: () async {
          await startXRSession(
              context, () => _flutterWebXrPlugin.createCube(sideLength: 0.2));
        },
        scene: ThreeScene(
          createdViewId: 'cube',
          object: _flutterWebXrPlugin.createCube(sideLength: 1),
        ),
      ),
      ThreeModel(
          name: 'Shiba',
          startARSession: () async {
            await startXRSession(
                context,
                () async => await _flutterWebXrPlugin
                    .loadGLTFModel('models/shiba/scene.gltf'));
          },
          scene: const ThreeScene(
            createdViewId: 'gltfObject',
            path: 'models/shiba/scene.gltf',
          )),
    ];
  }
  ```


  To determine if WebXR is supported on the user's platform, invoke the `isWebXrSupported` function, passing in the app's context. This function consults the `FlutterWebXr` plugin to verify WebXR availability. If any issue arises during this check, the function handles it gracefully, displaying an error message via `_showErrorSnackBar` and returns `false`, indicating the lack of support. On the other hand, if you aim to initiate a WebXR session, use the `startXRSession` method. You must provide both the app's context and a function, `createObject`, to define the 3D objects within the AR scene. If a hitch occurs during the session initiation, the function alerts the user with a relevant error message.


   ```dart
   bool isWebXrSupported(BuildContext context) {
    try {
      return _flutterWebXrPlugin.isWebXrAvailable();
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to check web xr availability');
      return false;
    }
  }

  Future<void> startXRSession(
      BuildContext context, Function createObject) async {
    try {
      createObject();
      await _flutterWebXrPlugin.startSession();
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to start web xr session');
    }
  }
```

For the main content in the body, the method checks the WebXR compatibility with the isWebXrSupported function. If WebXR is supported, it displays a grid of 3D models through the ObjectGrid widget, utilizing the models list. Conversely, if WebXR isn't supported, a center-aligned text message "WebXR not supported" is shown to inform the user. This method, thus, effectively tailors the display based on the device's compatibility with WebXR.


```dart
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Web AR Plugin')
        ),
        body: isWebXrSupported(context)
            ? ObjectGrid(models: models)
            : const Center(child: Text('WebXR not supported')));
  }
}
```


## Support and Contribution

If you encounter any issues or have suggestions for improvements, please open an issue on GitHub. Contributions to the development of this plugin in the form of pull requests are always welcome!


## Authors

- [Felix Günthner](https://github.com/Felix2019)

