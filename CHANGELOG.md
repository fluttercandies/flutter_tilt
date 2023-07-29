# Changelog

## Unreleased
### New features
- Add `border` to the `Tilt` widget.

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