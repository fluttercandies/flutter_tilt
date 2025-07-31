# Changelog

> [!IMPORTANT]  
> See the [Migration Guide](guides/migration_guide.md) for the details of breaking changes between versions.

## 3.2.2

### Improvements

- Update example and docs.

## 3.2.1

### Improvements

- Bump example to Flutter 3.29 ([#24](https://github.com/fluttercandies/flutter_tilt/pull/24))
- Refactor code structures. ([#23](https://github.com/fluttercandies/flutter_tilt/pull/23))

## 3.2.0

### New features

-  Add `Tilt.lightShadowMode` and configuration. ([#12](https://github.com/fluttercandies/flutter_tilt/pull/12))

### Improvements

- Migrate from `withOpacity` to `withAlpha`.

## 3.1.0

### Improvements

- Bump `sensors_plus` package from `6.0.0` to `6.1.0`. ([#20](https://github.com/fluttercandies/flutter_tilt/pull/20))
- Migrate the example to Android Studio Ladybug (JDK 21). ([#19](https://github.com/fluttercandies/flutter_tilt/pull/19))

## 3.0.6

### Improvements

- Replace `Platform` (dart:io) with `TargetPlatform` (flutter/foundation.dart). ([#18](https://github.com/fluttercandies/flutter_tilt/pull/18))
- Handling when the platform has no available sensors. ([#18](https://github.com/fluttercandies/flutter_tilt/pull/18))

## 3.0.5

### Fixes

- Fix `Tilt.disable: true` still prevents scrolling. ([#16](https://github.com/fluttercandies/flutter_tilt/pull/16))

## 3.0.4

### Fixes

- Fix `tiltConfig.enableGestureTouch` still prevents scrolling when disabled. ([#15](https://github.com/fluttercandies/flutter_tilt/pull/15))

### Improvements

- Improve example (Flutter v3.24.0)

## 3.0.3

### Improvements

- Bump `sensors_plus` package from `5.0.1` to `6.0.0`.

## 3.0.2

### Improvements

- Improve linter.

## 3.0.1

### Improvements

- Upgrade `sensors_plus` package to `5.0.1`.
- Update Doc.

## 3.0.0

### Breaking changes

- Bumping Flutter SDK minimum version to `3.19.0`.

### Improvements

- Upgrade `sensors_plus` package to `5.0.0`.

## 2.4.1

### Improvements

- dart doc.

## 2.4.0

### New features

- Add `Tilt.tiltStreamController` to provide custom control of the tilt.
- Add `TiltConfig.controllerMoveDuration`, `TiltConfig.controllerLeaveDuration`.

### Improvements

- Improve gesture priority logic.
- dart doc.

### Fixes

- Fix assignment usage logic in `Tilt.tiltStreamController`.
- Fix `Tilt.tiltStreamController` closes prematurely.
- Fix sensor listening not closed.

## 2.3.0

### Breaking changes

- Bumping Flutter SDK minimum version to `3.10.0`.

### Improvements

- Update Versions Compatibility.
  (Sensors are not supported on the web platform until Flutter version 3.10)

## 2.2.1

### Improvements

- Upgrade `sensors_plus` to version 4.0.2.
- Improve code structure.

### Fixes

- Fix `onGesturesRevert` being called repeatedly after a move has ended.

## 2.2.0

### Breaking changes

- Migrate to Flutter 3.7 and drop support for previous Flutter versions.
- Upgrade sensors_plus to v4.x.x. (#6)

### Improvements

- Improve example (Flutter v3.16.0)

## 2.1.2

### Improvements

- Improve high energy impact.

## 2.1.1

### Improvements

- Update the example to Flutter 3.16.0 and use Material3.

## 2.1.0

### New features

- Add spreadFactor to LightConfig.

## 2.0.10

### Fixes

- Fix undetermined mounted.

## 2.0.9

### Fixes

- Fix device orientation does not match sensor orientation.

## 2.0.8

### Improvements

- Improve README docs

## 2.0.7

### Improvements

- Upgrade `sensors_plus` to version 3.1.0

## 2.0.6

### Improvements

- Improve light above `childLayout.inner`.

### Fixes

- Fix incorrect initialization sizes in some cases (e.g. image with unspecified sizes).

## 2.0.5

### Improvements

- Improve code structure.

## 2.0.4

### Fixes

- Fix tapping on content causes tilt when `enableRevert` or `enableSensorRevert` is false.

## 2.0.3

### Fixes

- Fix device landscape mode not match sensor orientation.

## 2.0.2

### Improvements

- Config copyWith().

## 2.0.1

### Fixes

- Fix initial has no effect.

## 2.0.0

### Breaking changes

- Bumping Flutter SDK minimum version to `3.3.0`.
- Changed `enableMouseHover` in `TiltConfig` to `enableGestureHover`.
- To keep the tilt, you need to configure `TiltConfig(enableRevert: false, enableSensorRevert: false,)`.

### New features

- Add sensor gesture (configuration: `enableGestureSensors`, `sensorFactor`, `enableSensorRevert`, `sensorRevertFactor`, `sensorMoveDuration`), default configuration is `TiltConfig(enableGestureSensors = true)`.
- Add touch gesture configuration, default is `TiltConfig(enableGestureTouch = true)`.

### Improvements

- Gesture optimization.

## 1.0.4

### Fixes

- Fix `TiltConfig(enableReverse: true)` is not used in `TiltParallax`.
- Fix fps timer not canceled.


## 1.0.3

### Improvements

- Update `FilterQuality` parameter of `Tilt` and `TiltParallax` widgets is `null` by default.
- Upgrade Example of Flutter to 3.13.0

## 1.0.2

- Doc

## 1.0.1

- Doc

## 1.0.0

### Improvements

- Test coverage 100%.

## 0.1.2

### Fixes

- Fix `constraintsPosition` min value is wrong.
- Fix `TiltParallax` widget not following `Tilt` widget.

## 0.1.1

### Fixes

- Fix trigger touch and hover at the same time.

## 0.1.0

### Breaking changes

- The `childInner` parameter of the `Tilt widget` has been changed to `childLayout.outer`.

### New features
- Add `Tilt` widget `childLayout` parameter with multiple layouts.

## 0.0.9

### New features

- Add `border` to `Tilt` widget.
- Add animate `moveDuration`, `leaveDuration`, `moveCurve`, `leaveCurve` to `TiltConfig`.

## 0.0.8

### New features

- Add `GesturesType` to `onGestureMove` and `onGestureLeave`.

### Improvements

- Update the trigger of `onGestureLeave` when `TiltConfig.enableRevert = false`.
- Update `TiltConfig.enableRevert`.

### Fixes

- Fix `areaProgress` changing after resize.

## 0.0.7

- Docs

## 0.0.6

### Fixes

- Remove `onTiltBegin`, `onTiltEnd` and add `tiltDataModel` callback values to `onGestureMove`, `onGestureLeave`.

## 0.0.5

### Fixes

- Fix can't change parameters.
- Fix `Tilt.childInner` is removed when `Tilt.disable` is used.

## 0.0.3

### Fixes

- Fix `onGestureLeave` trigger when `TiltConfig.enableMouseHover = false`.

## 0.0.2

### Fixes

- Fix code for `analysis_options` warnings.
- Remove `TiltDirection` invalid `topBottom` and `leftRight`.

## 0.0.1

### New features

- `Tilt` widget supports `onTiltBegin`, `onTiltEnd`, `onGestureMove`, `onGestureLeave`.
- Upgrade `example` Flutter 3.10.6.  

## 0.0.1-dev.1

- Docs

## 0.0.1-dev.0

- Initial