[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_tilt?style=social&logo=github&logoColor=1F2328&label=stars)](https://github.com/fluttercandies/flutter_tilt)
[![Pub.dev likes](https://img.shields.io/pub/likes/flutter_tilt?style=social&logo=flutter&logoColor=168AFD&label=likes)](https://pub.dev/packages/flutter_tilt)

📓 Language: English | [中文](README-ZH.md)  
🎁 Check out the [Live Demo][].  
💡 See the [Migration Guide][] to learn how to migrate between breaking changes.  

<br/><br/>

<h1 align="center">
  Flutter Tilt
  <br/>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=stable&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=dev&logo=flutter&include_prereleases" alt="dev package" /></a>
</h1>

<p align="center">
  <a href="https://pub.dev/packages/flutter_tilt/score"><img src="https://img.shields.io/pub/dm/flutter_tilt?color=2E8B57&logo=flutter" alt="pub downloads" /></a>
  <a href="https://pub.dev/packages/flutter_tilt/score"><img src="https://img.shields.io/pub/points/flutter_tilt?color=2E8B57&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/fluttercandies/flutter_tilt"><img src="https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_tilt?color=0CAB6B&logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://codecov.io/gh/fluttercandies/flutter_tilt"><img src="https://img.shields.io/codecov/c/github/fluttercandies/flutter_tilt?label=coverage&logo=codecov" alt="codecov" /></a>
  <a href="https://pub.dev/packages/flutter_tilt/license"><img src="https://img.shields.io/github/license/fluttercandies/flutter_tilt?color=8EBC06" alt="license" /></a>
</p>

<p align="center">
  <strong >Easily apply tilt parallax hover effects for Flutter!</strong>
</p>

<br/>

<div align="center">
  <table width="620" align="center" border="0">
    <tr>
      <td align="right">
        <img width="285px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview2-small.gif" alt="Example Preview GIF - Parallax image" /><br/><img width="285px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview5-small.gif" alt="Example Preview GIF - Layout" />
      </td>
      <td align="left">
        <img width="320px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview4-small.gif" alt="Example Preview GIF - Parallax card" /><br/><img width="320px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview3-small.gif" alt="Example Preview GIF - Layout" />
      </td>
    </tr>
    <tr>
      <td align="center" colspan="2">

Check out the [Live Demo][].
      </td>
    </tr>
  </table>
</div>

<br/>

## Table of contents 🪄

<sub>

- [Features](#features-)

- [Install](#install-)

  - [Versions compatibility](#versions-compatibility-)

  - [Platforms compatibility](#platforms-compatibility-)

  - [Add package](#add-package-)

- [Sensors compatibility][]

- [Gesture priority](#gesture-priority-)

- [Simple usage](#simple-usage-)

  - [Tilt](#tilt-)

  - [Parallax](#parallax-)

- [Usage](#usage-)

  - [Tilt widget parameters][]

  - [TiltParallax widget parameters][]

  - [ChildLayout][]

  - [StreamController&lt;TiltStreamModel&gt;][]

  - [TiltConfig][]

  - [LightShadowMode][]

  - [LightConfig][]

  - [ShadowConfig][]

- [Contributors](#contributors-)

- [License](#license-)

</sub>

<br/>


## Features ✨  

- 📦 Tilt effect
- 🔦 Light effect
- 💡 Shadow effect
- 👀 Parallax effect
- 📱 Gyroscope sensor support ([Sensors compatibility][])
- 🧱 Multiple layouts
- 👇 Supports hover, touch and sensors events
- 🖼️ Smooth animation
- ⚙️ Many custom parameters


## Install 🎯
### Versions compatibility 🐦  

|       Flutter       |  3.0.0+  |  3.10.0+  |  3.19.0+  |  
|      ---------      | :------: | :-------: | :-------: |  
| flutter_tilt 3.0.0+ |    ❌    |    ❌    |    ✅    |  
| flutter_tilt 2.0.0+ |    ❌    |    ✅    |    ✅    |  
| flutter_tilt 1.0.0+ |    ✅    |    ❌    |    ❌    |  


### Platforms compatibility 📱  

| Android |  iOS  |  Web  | macOS | Windows | Linux |  
| :-----: | :---: | :---: | :---: | :-----: | :---: |  
|   ✅   |   ✅  |  ✅   |  ✅  |   ✅   |  ✅   |  


### Add package 📦  

Run this command with Flutter,  

```sh
$ flutter pub add flutter_tilt
```

or add `flutter_tilt` to `pubspec.yaml` dependencies manually.  

```yaml
dependencies:
  flutter_tilt: ^latest_version
```


## Sensors compatibility 📱  

Sensors will only trigger on these platforms.  
Platforms without sensors support do not affect the normal use of other features.  

| Android |  iOS  |                        Web (HTTPS)                       | macOS | Windows | Linux |  
| :-----: | :---: | :------------------------------------------------------: | :---: | :-----: | :---: |  
|   ✅   |   ✅  | [Browser compatibility][Gyroscope Browser compatibility] |  ❌  |   ❌    |  ❌  |  

> [!NOTE]  
> Currently Web uses the [Sensor API - Gyroscope], but it is not compatible with some of the major browsers, such as Safari, Firefox.  
<!-- > After that maybe replace it with [DeviceMotionEvent][]. -->


## Gesture priority 📱

When multiple gestures are enabled, they are triggered based on priority:

> Touch > Hover > Controller > Sensors


## Simple usage 📖  

Example: [flutter_tilt/example][]


### Tilt 📦  

[Tilt][Tilt widget parameters] widget will have default tilt, shadow, and light effects.  

```dart
/// Import flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

Tilt(
  child: Container(
    width: 150.0,
    height: 300.0,
    color: Colors.grey,
  ),
),

```


### Parallax 👀  

[TiltParallax][TiltParallax widget parameters] widget can only be used in the `childLayout` of `Tilt` widget.   

```dart
/// Import flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

Tilt(
  childLayout: const ChildLayout(
    outer: [
      /// Parallax here
      Positioned(
        child: TiltParallax(
          child: Text('Parallax'),
        ),
      ),
      /// Parallax here
      Positioned(
        top: 20.0,
        left: 20.0,
        child: TiltParallax(
          size: Offset(-10.0, -10.0),
          child: Text('Tilt'),
        ),
      ),
    ],
  ),
  child: Container(
    width: 150.0,
    height: 300.0,
    color: Colors.brown,
  ),
),

```


## Usage 📖  
### `Tilt` widget parameters 🤖  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | Create a widget that its child widget can be tilted. |  
| childLayout | [ChildLayout][] | `ChildLayout()` | Other child layouts. <br/> e.g. parallax outer, inner, behind. |  
| tiltStreamController | [StreamController&lt;TiltStreamModel&gt;][]? | `null` | `StreamController<TiltStreamModel>.broadcast()` to control the tilt. |  
| disable | `bool` | `false` | Disable all effects. |  
| fps | `int` | `120` | Gesture triggered frames. |  
| border | `BoxBorder?` | `null` | BoxDecoration border. |  
| borderRadius | `BorderRadiusGeometry?` | `null` | BoxDecoration borderRadius. |  
| clipBehavior | `Clip` | `Clip.antiAlias` | Flutter clipBehavior. |  
| tiltConfig | [TiltConfig][] | `TiltConfig()` | Tilt effect config. |  
| lightShadowMode | [LightShadowMode][] | `LightShadowMode.base` | Light & Shadow Mode. |  
| lightConfig | [LightConfig][] | `LightConfig()` | Light effect config. |  
| shadowConfig | [ShadowConfig][] | `ShadowConfig()` | Shadow effect config. |  
| onGestureMove | `void Function(TiltDataModel, GesturesType)?` | `null` | Gesture move callback. |  
| onGestureLeave | `void Function(TiltDataModel, GesturesType)?` | `null` | Gesture leave callback. |  


### `TiltParallax` widget parameters 🤖  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | Create a widget with parallax. |  
| size | `Offset` | `Offset(10.0, 10.0)` | Parallax size. |  
| filterQuality | `FilterQuality` | `null` | Flutter FilterQuality. |  


### ChildLayout 📄  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| outer | `List<Widget>` | `<Widget>[]` | As with Stack, you can use the Stack layout to create widgets that are outer of the child. <br/> e.g. parallax effects. |  
| inner | `List<Widget>` | `<Widget>[]` | As with Stack, you can use the Stack layout to create widgets that are inner of the child. <br/> e.g. parallax effects. |  
| behind | `List<Widget>` | `<Widget>[]` | As with Stack, you can use the Stack layout to create widgets that are behind of the child. <br/> e.g. parallax effects. |  


### StreamController&lt;TiltStreamModel&gt; 📄

```dart

final StreamController<TiltStreamModel> tiltStreamController =
      StreamController<TiltStreamModel>.broadcast();

/// The current gesture is being used
tiltStreamController.add(
  TiltStreamModel(
    position: Offset(xx, xx),
  ),
);

/// Stop using the current gesture
tiltStreamController.add(
  TiltStreamModel(
    position: Offset(xx, xx),
    gestureUse: false,
  ),
);

```

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| position <sup>`required`</sup> | `Offset` | - | The current trigger position, <br/> It will have the tilt effect of the corresponding position. <br/> e.g. <br/> There is a widget size, width: 10, height: 10, <br/> (0, 0): Maximum tilt top left. <br/> (10, 10): Maximum tilt bottom right. |  
| gesturesType | `GesturesType` | `GesturesType.controller` | Trigger gesture type. <br/> It is triggered according to the [gesture priority](#gesture-priority-). <br/> If you need to customize the control with animation or other means. <br/> `Recommended` use of `GesturesType.controller`. <br/> If other types are used for triggering, <br/> Then it will be affected by the configuration and effects associated with that type. <br/> e.g. <br/> When custom triggering `GesturesType.sensors`. <br/> If `TiltConfig.enableSensorRevert` is configured to be false, <br/> it will also not revert to the initial state. |  
| gestureUse | `bool` | `true` | Whether the gesture is being used. <br/> It is used to determine if the gesture is being used and will be processed according to the gesture priority. <br/> e.g. <br/> If `GesturesType.touch` is never assigned false when triggered, gestures with a lower priority than `GesturesType.touch` will never be triggered. |  


### TiltConfig 📄  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the tilt effect. |  
| initial | `Offset?` | `null` | Initial tilt progress, range `(x, y): (1, 1) to (-1, -1)`, <br/> you can exceed the range, but the maximum tilt angle during gesture movement is always tilted according to `[TiltConfig.angle]`. <br/> e.g. (0.0, 0.0) center <br/> (1.0, 1.0) Maximum tilt top left `[TiltConfig.angle]`. |  
| angle | `double` | `10.0` | Maximum tilt angle. <br/> e.g. 180 will flip. |  
| direction | `List<TiltDirection>?` | `null` | Tilt Direction, multiple directions, customized direction values. |  
| enableReverse | `bool` | `false` | Tilt reverse, can be tilted up or down. |  
| filterQuality | `FilterQuality` | `null` | Flutter FilterQuality. |  
| enableGestureSensors | `bool` | `true` | Gyroscope sensor triggered tilt. <br/> Only the following gestures: <br/> `GesturesType.sensors` |  
| sensorFactor | `double` | `10.0` | Sensor trigger factor (sensitivity). <br/> Only the following gestures: <br/> `GesturesType.sensors` |  
| enableSensorRevert | `bool` | `true` | Enable sensor tilt revert, will revert to the initial state. <br/> Only the following gestures: <br/> `GesturesType.sensors` |  
| sensorRevertFactor | `double` | `0.05` | Sensor revert factor (damping), range of values: `0-1`. <br/> Only the following gestures: <br/> `GesturesType.sensors` |  
| sensorMoveDuration | `Duration` | `Duration(milliseconds: 50)` | Animation duration during sensor move. <br/> Only the following gestures: <br/> `GesturesType.sensors` |  
| enableGestureHover | `bool` | `true` | Hover gesture triggered tilt. <br/> Only the following gestures: <br/> `GesturesType.hover` |  
| enableGestureTouch | `bool` | `true` | Touch gesture triggered tilt. <br/> Only the following gestures: <br/> `GesturesType.touch` |  
| enableRevert | `bool` | `true` | Enable tilt revert, will revert to the initial state. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` <br/> `GesturesType.controller` |  
| enableOutsideAreaMove | `bool` | `true` | Tilt can continue to be triggered outside the area. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.controller` |  
| enterDuration | `Duration` | `Duration(milliseconds: 1000)` | Animation duration during gesture enter, must be used with `[moveDuration]` and `[enterToMoveDuration]`. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| moveDuration | `Duration` | `Duration(milliseconds: 100)` | Animation duration during gesture move. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| enterToMoveDuration | `Duration` | `Duration(milliseconds: 600)` | The duration of the transition from enter to move, must be used with `[enterDuration]` and `[moveDuration]`. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| leaveDuration | `Duration` | `Duration(milliseconds: 300)` | Animation duration after gesture leave. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| moveCurve | `Curve` | `Curves.linear` | Animation curve during gesture move. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| enterToMoveCurve | `Curve` | `Curves.easeOutCubic` | The curve of the transition from enter to move, must be used with `[enterToMoveDuration]`. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| leaveCurve | `Curve` | `Curves.linear` | Animation curve after gesture leave. <br/> Only the following gestures: <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| controllerMoveDuration | `Duration` | `Duration(milliseconds: 100)` | Animation duration during controller gesture move. <br/> Only the following gestures: <br/> `GesturesType.controller` |  
| controllerLeaveDuration | `Duration` | `Duration(milliseconds: 300)` | Animation duration after controller gesture leave. <br/> Only the following gestures: <br/> `GesturesType.controller` |  


### LightShadowMode 📄

| Enum Value | Description |  
| --- | --- |
| LightShadowMode.base | `[No performance risk]` <br/> Use normal shadow effects only for `Tilt.child` without performance degradation. |  
| LightShadowMode.projector | `[Performance risk exists]` <br/> Apply a shadow to the entire `Tilt` widget, similar to a projector effect. <br/> will display a shadow that exactly matches the non-transparent parts of the widget. <br/> Recommended for the following scenarios: <br/> - Images only <br/> - No data states <br/> - No Hero tags |  


### LightConfig 📄  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the light effect. |  
| color | `Color` | `Color(0xFFFFFFFF)` | Light color. |  
| minIntensity | `double` | `0.0` | Color minimum opacity, also initial opacity. |  
| maxIntensity | `double` | `0.5` | Color maximum opacity for tilt progresses. |  
| spreadFactor | `double` | `4.0` | Light spread factor, relative to current widget size. |  
| projectorScale | `double` | `1.1` | Light area size scale. <br/> Only the following mode: <br/> `[LightShadowMode.projector]` |  
| direction | `LightDirection` | `LightDirection.around` | Light direction. <br/> Affects: <br/> `[ShadowConfig.direction]` (not affected after configuration). |  
| enableReverse | `bool` | `false` | Reverse light direction. <br/> Affects: <br/> `[ShadowConfig.direction]` (not affected after configuration). <br/> `[ShadowConfig.enableReverse]` (not affected after configuration). |  


### ShadowConfig 📄  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the shadow effect. |  
| color | `Color` | `Color(0xFF9E9E9E)` | Shadow color. |  
| minIntensity | `double` | `0.0` | Color minimum opacity, also initial opacity. |  
| maxIntensity | `double` | `0.5` | Color maximum opacity as tilt progresses. |  
| offsetInitial | `Offset` | `Offset(0.0, 0.0)` | Initial value of shadow offset. <br/> e.g. (0.0, 0.0) center. <br/> (40.0, 40.0) Offset 40 to the top left. |  
| offsetFactor | `double` | `0.1` | Shadow offset factor, relative to current widget size. |  
| spreadInitial | `double` | `0.0` | Initial value of shadow spread radius. <br/> Only the following mode: <br/> `[LightShadowMode.base]` |  
| spreadFactor | `double` | `0.0` | Shadow spread radius factor, relative to current widget size. <br/> Only the following mode: <br/> `[LightShadowMode.base]` |  
| minBlurRadius | `double` | `10.0` | Minimum blur radius, also initial blur radius. <br/> Only the following mode: <br/> `[LightShadowMode.base]` |  
| maxBlurRadius | `double` | `20.0` | Maximum blur radius for tilt progresses. <br/> Only the following mode: <br/> `[LightShadowMode.base]` |  
| projectorScaleFrom | `double` | `1.0` | Size scale for minimum progress, also initial size scale. <br/> Only the following mode: <br/> `[LightShadowMode.projector]` |  
| projectorScaleTo | `double` | `1.0` | Size scale for maximum progress. <br/> Only the following mode: <br/> `[LightShadowMode.projector]` |  
| projectorBlurSigmaFrom | `double` | `5.0` | Blur sigma for minimum progress, also initial blur sigma. <br/> Only the following mode: <br/> `[LightShadowMode.projector]` |  
| projectorBlurSigmaTo | `double` | `10.0` | Blur sigma for maximum progress. <br/> Only the following mode: <br/> `[LightShadowMode.projector]` |  
| direction | `ShadowDirection?` | `null` | Shadow direction. |  
| enableReverse | `bool?` | `null` | Reverse shadow direction. |  


## Contributors ✨  

See [graphs/contributors](https://github.com/fluttercandies/flutter_tilt/graphs/contributors) for more details.  
Contributions of any kind are welcome! ([emoji key](https://allcontributors.org/docs/en/emoji-key))  

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/AmosHuKe">
          <img src="https://avatars.githubusercontent.com/u/32262985?v=4" width="100px" alt="AmosHuKe"/>
          <br />
          <sub><b>AmosHuKe</b></sub>
          <br />
          <a href="https://github.com/fluttercandies/flutter_tilt/commits?author=AmosHuKe" title="Code">💻</a>&nbsp;
          <a href="https://github.com/fluttercandies/flutter_tilt/pulls?q=is:pr+reviewed-by:AmosHuKe" title="Reviewed Pull Requests">👀</a>&nbsp;
          <a href="https://github.com/fluttercandies/flutter_tilt/commits?author=AmosHuKe" title="Documentation">📖</a>&nbsp;
          <a href="https://github.com/AmosHuKe/flutter_tilt_book" title="Examples">💡</a>&nbsp;
          <a href="https://github.com/fluttercandies/flutter_tilt/commits?author=AmosHuKe" title="Tests">⚠️</a>&nbsp;
          <a href="#maintenance" title="Maintenance">🚧</a>&nbsp;
          <a href="#design" title="Design">🎨</a>&nbsp;
          <a href="#ideas" title="Ideas, Planning, & Feedback">🤔</a>&nbsp;
          <a href="#question" title="Answering Questions">💬</a>&nbsp;
          <br />
          <p align="left">
            <ul align="left">
              <li><sub>Example: <a href="https://github.com/AmosHuKe/flutter_tilt_book" title="Examples">flutter_tilt_book</a></sub></li>
            </ul>
          </p>
        </a>
      </td>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/LOCKEDFILE">
          <img src="https://avatars.githubusercontent.com/u/41106126?v=4" width="100px" alt="LOCKEDFILE"/>
          <br />
          <sub><b>LOCKEDFILE</b></sub>
          <br />
          <a href="https://github.com/fluttercandies/flutter_tilt/pulls?q=author:LOCKEDFILE" title="Bug reports">🐛</a>
        </a>
      </td>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/aytunch">
          <img src="https://avatars.githubusercontent.com/u/6442915?v=4" width="100px" alt="aytunc"/>
          <br />
          <sub><b>aytunch</b></sub>
          <br />
          <a href="https://github.com/fluttercandies/flutter_tilt/issues?q=author:aytunch" title="Ideas">🤔</a>
        </a>
      </td>
    </tr>
  <tbody>
</table>


## License 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/fluttercandies/flutter_tilt/blob/main/LICENSE)  
Open sourced under the MIT license.  

© AmosHuKe

[Live Demo]: https://amoshuke.github.io/flutter_tilt_book
[Migration Guide]: https://github.com/fluttercandies/flutter_tilt/blob/main/guides/migration_guide.md
[flutter_tilt/example]: https://github.com/fluttercandies/flutter_tilt/tree/main/example
[Sensors compatibility]: #sensors-compatibility-
[Tilt widget parameters]: #tilt-widget-parameters-
[TiltParallax widget parameters]: #tiltparallax-widget-parameters-
[ChildLayout]: #childlayout-
[StreamController&lt;TiltStreamModel&gt;]: #streamcontrollertiltstreammodel-
[TiltConfig]: #tiltconfig-
[LightShadowMode]: #lightshadowmode-
[LightConfig]: #lightconfig-
[ShadowConfig]: #shadowconfig-
[Gyroscope Browser compatibility]: https://developer.mozilla.org/en-US/docs/Web/API/Sensor_APIs#api.gyroscope
[Sensor API - Gyroscope]: https://developer.mozilla.org/en-US/docs/Web/API/Gyroscope
<!-- [DeviceMotionEvent]: https://developer.mozilla.org/en-US/docs/Web/API/DeviceMotionEvent -->
