/// Easily apply tilt parallax hover effects for Flutter,
/// which supports tilt, light, shadow effects, gyroscope sensors and many custom parameters.

// ignore_for_file: directives_ordering
// ignore: unnecessary_library_name
library flutter_tilt;

/// Configurations
export 'src/config/tilt_config.dart';
export 'src/config/tilt_light_config.dart';
export 'src/config/tilt_shadow_config.dart';
export 'src/enums.dart';

/// Controllers
export 'src/controllers/tilt_controller.dart' show TiltController;

/// Data Models
export 'src/models/tilt_data_model.dart' show TiltDataModel;
export 'src/models/tilt_stream_model.dart' show TiltStreamModel;

/// Main Widgets
export 'src/tilt.dart' show Tilt, TiltParallax;
export 'src/widgets/containers/tilt_base_container.dart' show TiltBaseContainer;
export 'src/widgets/containers/tilt_projector_container.dart'
    show TiltProjectorContainer;

/// Core Widgets
export 'src/widgets/core/tilt_animated_builder.dart' show TiltAnimatedBuilder;

/// Effects
export 'src/widgets/effects/tilt_light.dart' show TiltLight;
export 'src/widgets/effects/tilt_shadow.dart'
    show TiltShadowBase, TiltShadowProjector;
