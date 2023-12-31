# Migration Guide

This document gathered all breaking changes and migrations requirement between major versions.

## Major versions

- [2.0.0](#200)
- [0.1.0](#010)

## 2.0.0

### Summary

- Bumping Flutter SDK minimum version to `3.3.0`.
- Changed `enableMouseHover` in `TiltConfig` to `enableGestureHover`.
- To keep the tilt, you need to configure `TiltConfig(enableRevert: false, enableSensorRevert: false,)`.

### Details

#### Changed `enableMouseHover` in `TiltConfig` to `enableGestureHover`.

```diff
Tilt(
  tiltConfig: TiltConfig(
-   enableMouseHover: false
+   enableGestureHover: false
  )
  ...
)
```

#### To keep the tilt.

```diff
Tilt(
  tiltConfig: TiltConfig(
+    enableRevert: false,
+    enableSensorRevert: false,
  )
  ...
)
```

## 0.1.0

### Summary

The `childInner` parameter of the `Tilt widget` has been changed to `childLayout.outer`.

### Details

Before:

```dart
Tilt(
  childInner: [
    /// code
  ]
  ...
)
```

After:

```dart
Tilt(
  childLayout: ChildLayout(
    outer: [
      /// code
    ]
  )
  ...
)
```