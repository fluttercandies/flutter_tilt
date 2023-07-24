Language: English | [中文](README-ZH.md)</a>

<br/>

<h1 align="center">Flutter Tilt</h1>

<p align="center">
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=stable&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=dev&logo=flutter&include_prereleases" alt="dev package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt/score"><img src="https://img.shields.io/pub/points/flutter_tilt?color=2E8B57&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/amoshuke/flutter_tilt"><img src="https://img.shields.io/codefactor/grade/github/amoshuke/flutter_tilt?logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://github.com/AmosHuKe/flutter_tilt/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License" /></a>
</p>

<p align="center">
  <strong >Easily Apply Tilt Parallax Hover Effects on Flutter!</strong>
</p>

<br/>

<div align="center">
  <img src="https://github.com/AmosHuKe/flutter_tilt/blob/main/README/preview.gif?raw=true" width="320px" style="border-radius: 20px;" />

  <p>Check out the <a href="https://amoshuke.github.io/flutter_tilt_book">Live Demo</a> (🚧 WIP)<p>
</div>

<br/>

## Table of contents 🪄

<sub>

- [Features](#features-)

- [Install](#install-)

  - [Versions compatibility](#versions-compatibility-)

  - [Add package](#add-package-)

- [Usage](#usage-)

  - [Simple usage: Tilt](#simple-usage-tilt-)

    - [Tilt widget parameters](#tilt-widget-parameters)

    - [TiltConfig](#tiltconfig)

    - [LightConfig](#lightconfig)

    - [ShadowConfig](#shadowconfig)

  - [Simple usage: Parallax](#simple-usage-parallax-)

    - [TiltParallax widget parameters](#tiltparallax-widget-parameters)

- [License](#license-)

</sub>

<br/>


## Features ✨  

- 📦 Tilt effect
- 🔦 Light effect
- 💡 Shadow effect
- 👀 Parallax effect
- 👇 Supports mouse and touch events
- 🖼️ Smooth animation
- ⚙️ Many custom parameters


## Install 🎯
### Versions compatibility 🐦  

|-       | 3.0.x | 3.3.x | 3.10.x |  
|--------|:-----:|:-----:|:------:|  
| 0.0.1+ |  ✅  |  ✅  |  ✅  |  


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


## Usage 📖  

Example: [flutter_tilt/example](https://github.com/AmosHuKe/flutter_tilt/tree/main/example)


### Simple usage: Tilt 📦  

`Tilt` widget will have default tilt, shadow, and light effects.
```dart
/// Import flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

...
Tilt(
  child: Container(
    width: 150.0,
    height: 300.0,
    color: Colors.grey,
  ),
),
... 
```


#### `Tilt` widget parameters  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | Create a widget that its child widget can be tilted. |  
| childInner | `List<Widget>` | `<Widget>[]` | As with Stack, you can use the Stack layout to create widgets that are above the child. <br/> e.g. parallax effects. |  
| disable | `bool` | `false` | Disable all effects. |  
| fps | `int` | `60` | Gesture triggered frames. |  
| borderRadius | `BorderRadiusGeometry?` | `null` | If non-null, the corners of this box are rounded by this `BorderRadius`. |  
| clipBehavior | `Clip` | `Clip.antiAlias` | Flutter clipBehavior. |  
| tiltConfig | `TiltConfig` | `TiltConfig()` | Tilt effect config. |  
| lightConfig | `LightConfig` | `LightConfig()` | Light effect config. |  
| shadowConfig | `ShadowConfig` | `ShadowConfig()` | Shadow effect config. |  
| onGestureMove | `void Function(TiltDataModel tiltDataModel)?` | `null` | Gesture move callback. |  
| onGestureLeave | `void Function(TiltDataModel tiltDataModel)?` | `null` | Gesture leave callback. |  


##### `TiltConfig`  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the tilt effect. |  
| initial | `Offset?` | `null` | Initial tilt progress, range `(x, y): (1, 1) to (-1, -1)`, <br/> you can exceed the range, but the maximum tilt angle during gesture movement is always tilted according to `[TiltConfig.angle]`. <br/> e.g. (0.0, 0.0) center <br/> (1.0, 1.0) Maximum tilt top left `[TiltConfig.angle]`. |  
| angle | `double` | `10.0` | Maximum tilt angle. <br/> e.g. 180 will flip. |  
| direction | `List<TiltDirection>?` | `null` | Tilt Direction, multiple directions, customized direction values. |  
| enableRevert | `bool` | `true` | Enable Tilt Revert, will revert to the initial state. |  
| enableReverse | `bool` | `false` | Tilt reverse, can be tilted up or down. |  
| enableOutsideAreaMove | `bool` | `true` | Tilt can continue to be triggered outside the area. <br/> (`only when the pointer is pressed and moved`) |  
| enableMouseHover | `bool` | `true` | Mouse hover to trigger tilt. |  
| filterQuality | `FilterQuality` | `FilterQuality.high` | Flutter FilterQuality. |  


##### `LightConfig`  
| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the light effect. |  
| color | `Color` | `Color(0xFFFFFFFF)` | Light color. |  
| minIntensity | `double` | `0.0` | Color minimum opacity, also initial opacity. |  
| maxIntensity | `double` | `0.5` | Color maximum opacity for tilt progresses. |  
| direction | `LightDirection` | `LightDirection.around` | Light direction. <br/> Affects: <br/> `[ShadowConfig.direction]` (not affected after configuration). |  
| enableReverse | `bool` | `false` | Reverse light direction. <br/> Affects: <br/> `[ShadowConfig.direction]` (not affected after configuration). <br/> `[ShadowConfig.enableReverse]` (not affected after configuration). |  


##### `ShadowConfig`  
| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | Only disable the shadow effect. |  
| color | `Color` | `Color(0xFF9E9E9E)` | Shadow color. |  
| minIntensity | `double` | `0.0` | Color minimum opacity, also initial opacity. |  
| maxIntensity | `double` | `0.5` | Color maximum opacity as tilt progresses. |  
| offsetInitial | `Offset` | `Offset(0.0, 0.0)` | Initial value of shadow offset (pixel). <br/> e.g. (0.0, 0.0) center. <br/> (40.0, 40.0) Offset 40 pixels to the top left. |  
| offsetFactor | `double` | `0.1` | Shadow offset factor, relative to current widget size. |  
| spreadInitial | `double` | `0.0` | Initial value of shadow spread radius (pixel). |  
| spreadFactor | `double` | `0.0` | Shadow spread radius factor, relative to current widget size. |  
| minBlurRadius | `double` | `10.0` | Minimum blur radius, also initial blur radius. |  
| maxBlurRadius | `double` | `20.0` | Maximum blur radius for tilt progresses. |  
| direction | `ShadowDirection?` | `null` | Shadow direction. |  
| enableReverse | `bool?` | `null` | Reverse shadow direction. |  


### Simple usage: Parallax 👀  

`TiltParallax` widget can only be used in the `childInner` of `Tilt` widget.   
`childInner` is the same as `Stack` widget.
```dart
/// Import flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

...
Tilt(
  childInner: const [
    /// Parallax here
    Positioned.fill(
      child: Center(
        child: TiltParallax(
          child: Text('Parallax'),
        ),
      ),
    ),
    /// Parallax here
    Positioned.fill(
      top: 20.0,
      left: 20.0,
      child: TiltParallax(
        size: Offset(-10.0, -10.0),
        child: Text('Tilt'),
      ),
    ),
  ],
  child: Container(
    width: 150.0,
    height: 300.0,
    color: Colors.brown,
  ),
),
... 
```


#### `TiltParallax` widget parameters  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | Create a widget with parallax. |  
| size | `Offset` | `Offset(10.0, 10.0)` | Parallax size (pixel). |  
| filterQuality | `FilterQuality` | `FilterQuality.high` | Flutter FilterQuality. |  


## License 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AmosHuKe/flutter_tilt/blob/main/LICENSE)  
Open sourced under the MIT license.  

© AmosHuKe
