# Changelog

> [!IMPORTANT]  
> See the [Migration Guides](https://amoshuke.github.io/flutter_tilt_book/en/v4/docs/migration-guides/) for the details of breaking changes between versions.

## 4.0.1 (2026-06-04)

**Improvements**

- Isolate tilt repaints with a `RepaintBoundary` to avoid repainting the parent subtree during animation. ([#41](https://github.com/fluttercandies/flutter_tilt/pull/41))
- Avoid redundant calculations and optimize performance. ([#41](https://github.com/fluttercandies/flutter_tilt/pull/41))

## 4.0.0 (2026-05-12)

Migration Guide: [English](https://amoshuke.github.io/flutter_tilt_book/en/v4/docs/migration-guides/migrate-to-v4-0-0/) | [中文](https://amoshuke.github.io/flutter_tilt_book/zh/v4/docs/migration-guides/migrate-to-v4-0-0/)  

**Breaking changes**

- `Tilt` widget now only manages gesture, sensor, and animation state (no UI rendering).  
  To reproduce the previous default style, you need to compose `TiltBaseContainer` with `Tilt`, or use the built-in `Tilt.base`.  
- Replace `Tilt.TiltStreamController` with `Tilt.TiltController` to unify input stream management.
- The previous `Tilt.lightShadowMode` parameter has been split into the independent widgets `TiltBaseContainer` and `TiltProjectorContainer`.  
  To reproduce the previous style, you need to compose them inside the `Tilt` widget,  
  or use `Tilt.base` and `Tilt.projector` directly.  
- `ShadowConfig` has been split into `ShadowBaseConfig` and `ShadowProjectorConfig`.
- Rename `TiltParallax` parameter `size` to `offset`.

**Deprecations**

- The `lightConfig` of `TiltProjectorContainer` is now deprecated.  
  Because the current simulated light effect is not suitable for Projector,  
  it is now disabled by default and will be removed in a future release.  

**New features**

- Add `TiltAnimatedBuilder` to help implement custom tilt logic.

[PR #34](https://github.com/fluttercandies/flutter_tilt/pull/34)

## 3.3.5 (2026-04-28)

**Improvements**

- Updated README.md

## 3.3.4 (2026-04-08)

**Improvements**

- Simulated light reflection is more natural.
- Avoid redundant calculations and optimize performance.

**Fixes**

- Return `moveDuration` when enterToMove animation progress >= 1

## 3.3.3 (2026-04-01)

**Improvements**

- Remove stream_transform package.

## 3.3.2 (2025-09-17)

**Improvements**

- Bump `sensors_plus` package to `'>=6.1.0 <8.0.0'`.

## 3.3.1 (2025-08-28)

**Improvements**

- Reduce unnecessary animation controllers (multiple `TiltParallax` widgets share the same controller). ([#30](https://github.com/fluttercandies/flutter_tilt/pull/30))

## 3.3.0 (2025-08-26)

**New features**

- By default, add a smooth transition effect when gestures (hover and touch) enter. ([#29](https://github.com/fluttercandies/flutter_tilt/pull/29))
  - Configurable via:
    - `TiltConfig.enterDuration`
    - `TiltConfig.moveDuration`
    - `TiltConfig.enterToMoveDuration`
    - `TiltConfig.enterToMoveCurve`

  If you prefer to disable this effect:

  ```dart
  Tilt(
    tiltConfig: TiltConfig(
      enterToMoveDuration: Duration.zero,
      ...
    )
    ...
  )
  ```

## 3.2.3 (2025-08-14)

**Improvements**

- Improve performance (e.g. avoid unnecessary variable assignments, ...). ([#27](https://github.com/fluttercandies/flutter_tilt/pull/27))
- Refactor code structures. ([#27](https://github.com/fluttercandies/flutter_tilt/pull/27))
- The `Tilt.fps` default value has been changed from 60 to 120. ([#27](https://github.com/fluttercandies/flutter_tilt/pull/27))

## 3.2.2 (2025-07-31)

**Improvements**

- Update example and docs.

## 3.2.1 (2025-03-12)

**Improvements**

- Bump example to Flutter 3.29 ([#24](https://github.com/fluttercandies/flutter_tilt/pull/24))
- Refactor code structures. ([#23](https://github.com/fluttercandies/flutter_tilt/pull/23))

## 3.2.0 (2024-12-13)

**New features**

- Add `Tilt.lightShadowMode` and configuration. ([#12](https://github.com/fluttercandies/flutter_tilt/pull/12))

**Improvements**

- Migrate from `withOpacity` to `withAlpha`.

## 3.1.0 (2024-10-21)

**Improvements**

- Bump `sensors_plus` package from `6.0.0` to `6.1.0`. ([#20](https://github.com/fluttercandies/flutter_tilt/pull/20))
- Migrate the example to Android Studio Ladybug (JDK 21). ([#19](https://github.com/fluttercandies/flutter_tilt/pull/19))

## 3.0.6 (2024-09-06)

**Improvements**

- Replace `Platform` (dart:io) with `TargetPlatform` (flutter/foundation.dart). ([#18](https://github.com/fluttercandies/flutter_tilt/pull/18))
- Handling when the platform has no available sensors. ([#18](https://github.com/fluttercandies/flutter_tilt/pull/18))

## 3.0.5 (2024-08-14)

**Fixes**

- Fix `Tilt.disable: true` still prevents scrolling. ([#16](https://github.com/fluttercandies/flutter_tilt/pull/16))

## 3.0.4 (2024-08-14)

**Fixes**

- Fix `tiltConfig.enableGestureTouch` still prevents scrolling when disabled. ([#15](https://github.com/fluttercandies/flutter_tilt/pull/15))

**Improvements**

- Improve example (Flutter v3.24.0)

## 3.0.3 (2024-07-30)

**Improvements**

- Bump `sensors_plus` package from `5.0.1` to `6.0.0`.

## 3.0.2 (2024-06-06)

**Improvements**

- Improve linter.

## 3.0.1 (2024-04-11)

**Improvements**

- Upgrade `sensors_plus` package to `5.0.1`.
- Update Doc.

## 3.0.0 (2024-03-20)

**Breaking changes**

- Bumping Flutter SDK minimum version to `3.19.0`.

**Improvements**

- Upgrade `sensors_plus` package to `5.0.0`.

## 2.4.1 (2024-03-13)

**Improvements**

- dart doc.

## 2.4.0 (2024-02-20)

**New features**

- Add `Tilt.tiltStreamController` to provide custom control of the tilt.
- Add `TiltConfig.controllerMoveDuration`, `TiltConfig.controllerLeaveDuration`.

**Improvements**

- Improve gesture priority logic.
- dart doc.

**Fixes**

- Fix assignment usage logic in `Tilt.tiltStreamController`.
- Fix `Tilt.tiltStreamController` closes prematurely.
- Fix sensor listening not closed.

## 2.3.0 (2024-02-08)

**Breaking changes**

- Bumping Flutter SDK minimum version to `3.10.0`.

**Improvements**

- Update Versions Compatibility.
  (Sensors are not supported on the web platform until Flutter version 3.10)

## 2.2.1 (2023-12-14)

**Improvements**

- Upgrade `sensors_plus` to version 4.0.2.
- Improve code structure.

**Fixes**

- Fix `onGesturesRevert` being called repeatedly after a move has ended.

## 2.2.0 (2023-11-27)

**Breaking changes**

- Migrate to Flutter 3.7 and drop support for previous Flutter versions.
- Upgrade sensors_plus to v4.x.x. (#6)

**Improvements**

- Improve example (Flutter v3.16.0)

## 2.1.2 (2023-11-20)

**Improvements**

- Improve high energy impact.

## 2.1.1 (2023-11-16)

**Improvements**

- Update the example to Flutter 3.16.0 and use Material3.

## 2.1.0 (2023-11-09)

**New features**

- Add spreadFactor to LightConfig.

## 2.0.10 (2023-10-30)

**Fixes**

- Fix undetermined mounted.

## 2.0.9 (2023-10-29)

**Fixes**

- Fix device orientation does not match sensor orientation.

## 2.0.8 (2023-10-23)

**Improvements**

- Improve README docs

## 2.0.7 (2023-10-22)

**Improvements**

- Upgrade `sensors_plus` to version 3.1.0

## 2.0.6 (2023-10-02)

**Improvements**

- Improve light above `childLayout.inner`.

**Fixes**

- Fix incorrect initialization sizes in some cases (e.g. image with unspecified sizes).

## 2.0.5 (2023-09-27)

**Improvements**

- Improve code structure.

## 2.0.4 (2023-09-20)

**Fixes**

- Fix tapping on content causes tilt when `enableRevert` or `enableSensorRevert` is false.

## 2.0.3 (2023-09-19)

**Fixes**

- Fix device landscape mode not match sensor orientation.

## 2.0.2 (2023-09-15)

**Improvements**

- Config copyWith().

## 2.0.1 (2023-09-11)

**Fixes**

- Fix initial has no effect.

## 2.0.0 (2023-09-07)

**Breaking changes**

- Bumping Flutter SDK minimum version to `3.3.0`.
- Changed `enableMouseHover` in `TiltConfig` to `enableGestureHover`.
- To keep the tilt, you need to configure `TiltConfig(enableRevert: false, enableSensorRevert: false,)`.

**New features**

- Add sensor gesture (configuration: `enableGestureSensors`, `sensorFactor`, `enableSensorRevert`, `sensorRevertFactor`, `sensorMoveDuration`), default configuration is `TiltConfig(enableGestureSensors = true)`.
- Add touch gesture configuration, default is `TiltConfig(enableGestureTouch = true)`.

**Improvements**

- Gesture optimization.

## 1.0.4 (2023-08-31)

**Fixes**

- Fix `TiltConfig(enableReverse: true)` is not used in `TiltParallax`.
- Fix fps timer not canceled.

## 1.0.3 (2023-08-17)

**Improvements**

- Update `FilterQuality` parameter of `Tilt` and `TiltParallax` widgets is `null` by default.
- Upgrade Example of Flutter to 3.13.0

## 1.0.2 (2023-08-15)

- Doc

## 1.0.1 (2023-08-04)

- Doc

## 1.0.0 (2023-08-04)

**Improvements**

- Test coverage 100%.

## 0.1.2 (2023-08-03)

**Fixes**

- Fix `constraintsPosition` min value is wrong.
- Fix `TiltParallax` widget not following `Tilt` widget.

## 0.1.1 (2023-07-31)

**Fixes**

- Fix trigger touch and hover at the same time.

## 0.1.0 (2023-07-30)

**Breaking changes**

- The `childInner` parameter of the `Tilt widget` has been changed to `childLayout.outer`.

**New features**

- Add `Tilt` widget `childLayout` parameter with multiple layouts.

## 0.0.9 (2023-07-29)

**New features**

- Add `border` to `Tilt` widget.
- Add animate `moveDuration`, `leaveDuration`, `moveCurve`, `leaveCurve` to `TiltConfig`.

## 0.0.8 (2023-07-26)

**New features**

- Add `GesturesType` to `onGestureMove` and `onGestureLeave`.

**Improvements**

- Update the trigger of `onGestureLeave` when `TiltConfig.enableRevert = false`.
- Update `TiltConfig.enableRevert`.

**Fixes**

- Fix `areaProgress` changing after resize.

## 0.0.7 (2023-07-25)

- Docs

## 0.0.6 (2023-07-24)

**Fixes**

- Remove `onTiltBegin`, `onTiltEnd` and add `tiltDataModel` callback values to `onGestureMove`, `onGestureLeave`.

## 0.0.5 (2023-07-24)

**Fixes**

- Fix can't change parameters.
- Fix `Tilt.childInner` is removed when `Tilt.disable` is used.

## 0.0.3 (2023-07-23)

**Fixes**

- Fix `onGestureLeave` trigger when `TiltConfig.enableMouseHover = false`.

## 0.0.2 (2023-07-22)

**Fixes**

- Fix code for `analysis_options` warnings.
- Remove `TiltDirection` invalid `topBottom` and `leftRight`.

## 0.0.1 (2023-07-22)

**New features**

- `Tilt` widget supports `onTiltBegin`, `onTiltEnd`, `onGestureMove`, `onGestureLeave`.
- Upgrade `example` Flutter 3.10.6.  

## 0.0.1-dev.1 (2023-07-18)

- Docs

## 0.0.1-dev.0 (2023-07-17)

- Wowwwwww
