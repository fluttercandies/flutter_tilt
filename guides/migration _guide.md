# Migration Guide

This document gathered all breaking changes and migrations requirement between major versions.

## Major versions

- [0.1.0](#010)

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