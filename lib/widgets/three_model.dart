import 'package:flutter_web_xr/widgets/three_scene.dart';

/// `ThreeModel` is a class designed to encapsulate the data and functionality related to
/// a 3D model to be utilized within an AR (Augmented Reality) session.
///
/// It stores the model's name, a function to initiate the AR session, and an instance of `ThreeScene`
/// that represents the 3D scene/model.
class ThreeModel {
  /// A `String` that represents the name of the 3D model.
  ///
  /// This property should not be empty.
  final String name;

  /// A `Function` which, when called, starts the AR session for the associated 3D model.
  ///
  /// This is expected to contain all logic necessary to initiate and manage the AR experience.
  final Function startARSession;

  /// An instance of `ThreeScene` that represents the 3D model/scene to be displayed and interacted with.
  ///
  /// `ThreeScene` typically contains all the visual data and methods necessary to render the 3D model.
  final ThreeScene scene;

  /// Creates a new instance of `ThreeModel`.
  ///
  /// - `name`: A non-empty string representing the name of the 3D model.
  /// - `startARSession`: A function that encapsulates the logic for initiating an AR session for the model.
  /// - `scene`: An instance of `ThreeScene` representing the 3D scene/model.
  ///
  /// An assertion checks that the provided `name` is non-empty to ensure model identification.
  ThreeModel({
    required this.name,
    required this.startARSession,
    required this.scene,
  }) : assert(name.isNotEmpty, 'Model name must not be empty.');
}
