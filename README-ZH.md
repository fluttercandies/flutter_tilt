📓 语言：[English](README.md) | 中文  
🎁 查看：[在线示例][]  
💡 查看：[迁移指南][] 了解如何从破坏性改动中迁移为可用代码  

<br/>

<div align="center">
  <img height="180" src="https://raw.githubusercontent.com/AmosHuKe/flutter_tilt/main/README/preview2.gif" alt="示例预览 GIF - 图片视差" />
  <img height="180" src="https://raw.githubusercontent.com/AmosHuKe/flutter_tilt/main/README/preview3-small.gif" alt="示例预览 GIF - 布局" />
</div>

<br/>

<h1 align="center">Flutter Tilt</h1>

<p align="center">
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=%E7%A8%B3%E5%AE%9A&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=%E5%BC%80%E5%8F%91&logo=flutter&include_prereleases" alt="dev package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt/score"><img src="https://img.shields.io/pub/points/flutter_tilt?color=2E8B57&label=%E5%88%86%E6%95%B0&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/amoshuke/flutter_tilt"><img src="https://img.shields.io/codefactor/grade/github/amoshuke/flutter_tilt?color=0CAB6B&label=%E4%BB%A3%E7%A0%81%E8%B4%A8%E9%87%8F&logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://codecov.io/gh/AmosHuKe/flutter_tilt"><img src="https://img.shields.io/codecov/c/github/amoshuke/flutter_tilt?label=%E6%B5%8B%E8%AF%95%E8%A6%86%E7%9B%96&logo=codecov" alt="codecov" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/github/languages/top/amoshuke/flutter_tilt?color=00B4AB" alt="top language" /></a>
</p>

<p align="center">
  <strong >在 Flutter 上轻松创建倾斜视差悬停效果！</strong>
</p>

<br/>

<div align="center">
  <img width="320px" src="https://raw.githubusercontent.com/AmosHuKe/flutter_tilt/main/README/preview.gif" style="border-radius: 20px;" alt="示例预览 GIF"/>
</div>

<br/>

## 目录 🪄

<sub>

- [特性](#特性-)

- [安装](#安装-)

  - [版本兼容](#版本兼容-)

  - [添加 flutter_tilt](#添加-flutter_tilt-)

- [使用](#使用-)

  - [简单用法：倾斜](#简单用法倾斜-)

    - [Tilt widget 参数](#tilt-widget-参数)

    - [ChildLayout](#childlayout)

    - [TiltConfig](#tiltconfig)

    - [LightConfig](#lightconfig)

    - [ShadowConfig](#shadowconfig)

  - [简单用法：视差](#简单用法视差-)

    - [TiltParallax widget 参数](#tiltparallax-widget-参数)

- [许可证](#许可证-)

</sub>

<br/>


## 特性 ✨  

- 📦 倾斜效果
- 🔦 光照效果
- 💡 阴影效果
- 👀 视差效果
- 🧱 多种布局位置
- 👇 支持鼠标和触摸事件
- 🖼️ 流畅的动画
- ⚙️ 许多自定义参数


## 安装 🎯
### 版本兼容 🐦  

|-       | 3.0.x | 3.3.x | 3.10.x |  
|--------|:-----:|:-----:|:------:|  
| 0.0.1+ |  ✅  |  ✅  |  ✅  |  


### 添加 flutter_tilt 📦  

使用 Flutter 运行以下指令，  

```sh
$ flutter pub add flutter_tilt
```

或手动将 `flutter_tilt` 添加到 `pubspec.yaml` 依赖项中。  

```yaml
dependencies:
  flutter_tilt: ^latest_version
```


## 使用 📖  

示例：[flutter_tilt/example](https://github.com/AmosHuKe/flutter_tilt/tree/main/example)


### 简单用法：倾斜 📦  

`Tilt` widget 默认有倾斜、阴影和光照的效果。  

```dart
/// 导入 flutter_tilt
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


#### `Tilt` widget 参数  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | 创建一个 widget，使 child widget 有倾斜效果。 |  
| childLayout | `ChildLayout` | `ChildLayout()` | 其它 child 布局. <br/> 例如：位于 child 外部、内部、后面的视差布局. |  
| disable | `bool` | `false` | 禁用所有效果。 |  
| fps | `int` | `60` | 手势触发的帧数。 |  
| border | `BoxBorder?` | `null` | BoxDecoration border。 |  
| borderRadius | `BorderRadiusGeometry?` | `null` | BoxDecoration borderRadius。 |  
| clipBehavior | `Clip` | `Clip.antiAlias` | Flutter 中的 clipBehavior。 |  
| tiltConfig | `TiltConfig` | `TiltConfig()` | 倾斜效果配置。 |  
| lightConfig | `LightConfig` | `LightConfig()` | 光照效果配置。 |  
| shadowConfig | `ShadowConfig` | `ShadowConfig()` | 阴影效果配置。 |  
| onGestureMove | `void Function(TiltDataModel, GesturesType)?` | `null` | 手势移动的回调触发。 |  
| onGestureLeave | `void Function(TiltDataModel, GesturesType)?` | `null` | 手势离开的回调触发。 |  


##### ChildLayout  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| outer | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 外部` 的 widget。 <br/> 例如：视差效果。 |  
| inner | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 内部` 的 widget。 <br/> 例如：视差效果。 |  
| behind | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 后面` 的 widget。 <br/> 例如：视差效果。 |  


##### TiltConfig  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用倾斜效果。 |  
| initial | `Offset?` | `null` | 倾斜进度的初始值，范围 `(x, y)：(1, 1) 至 (-1, -1)`，<br/> 你可以超过这个范围，但是手势移动过程中的最大倾斜角度始终按照 `[TiltConfig.angle]` 进行倾斜。 <br/> 例如：(0.0, 0.0) 中心 <br/> (1.0, 1.0) 左上角最大倾斜角度 `[TiltConfig.angle]`。 |  
| angle | `double` | `10.0` | 最大倾斜角度。 <br/> 例如：180 会翻转。 |  
| direction | `List<TiltDirection>?` | `null` | 倾斜方向，多方向、自定义方向值。 |  
| enableRevert | `bool` | `true` | 启用倾斜复原，会复原至初始状态。 |  
| enableReverse | `bool` | `false` | 倾斜反向，可以向上或向下倾斜。 |  
| enableOutsideAreaMove | `bool` | `true` | 可以继续在区域外触发倾斜。 <br/> (`仅在指针按下并移动时`) |  
| enableMouseHover | `bool` | `true` | 鼠标 hover 触发倾斜。 |  
| moveDuration | `Duration` | `Duration(milliseconds: 100)` | 手势移动时的动画持续时间。 |  
| leaveDuration | `Duration` | `Duration(milliseconds: 300)` | 手势离开后的动画持续时间。 |  
| moveCurve | `Curve` | `Curves.linear` | 手势移动时的动画曲线。 |  
| leaveCurve | `Curve` | `Curves.linear` | 手势离开后的动画曲线。 |  
| filterQuality | `FilterQuality` | `FilterQuality.high` | Flutter FilterQuality。 |  


##### LightConfig  
| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用光照效果。 |  
| color | `Color` | `Color(0xFFFFFFFF)` | 光照颜色。 |  
| minIntensity | `double` | `0.0` | 颜色最小不透明度，也是初始不透明度。 |  
| maxIntensity | `double` | `0.5` | 颜色最大不透明度，跟随倾斜最大进度。 |  
| direction | `LightDirection` | `LightDirection.around` | 光照方向。 <br/> 影响：<br/> `[ShadowConfig.direction]`（配置后不受影响）。 |  
| enableReverse | `bool` | `false` | 方向光照方向。 <br/> 影响：<br/> `[ShadowConfig.direction]`（配置后不受影响）。 <br/> `[ShadowConfig.enableReverse]`（配置后不受影响）。 |  


##### ShadowConfig  
| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用阴影效果。 |  
| color | `Color` | `Color(0xFF9E9E9E)` | 阴影颜色。 |  
| minIntensity | `double` | `0.0` | 颜色最小不透明度，也是初始不透明度。 |  
| maxIntensity | `double` | `0.5` | 颜色最大不透明度，跟随倾斜最大进度。 |  
| offsetInitial | `Offset` | `Offset(0.0, 0.0)` | 阴影偏移初始值（像素单位）。 <br/> 例如：(0.0, 0.0) 中心 <br/> (40.0, 40.0) 向左上角偏移 40 像素。 |  
| offsetFactor | `double` | `0.1` | 阴影偏移系数，相对于当前 widget 尺寸。 |  
| spreadInitial | `double` | `0.0` | 阴影扩散半径初始值（像素单位）。 |  
| spreadFactor | `double` | `0.0` | 阴影扩散半径系数，相对于当前 widget 尺寸。 |  
| minBlurRadius | `double` | `10.0` | 最小阴影模糊半径，也是初始模糊半径。 |  
| maxBlurRadius | `double` | `20.0` | 最大阴影模糊半径，跟随倾斜最大进度。 |  
| direction | `ShadowDirection?` | `null` | 阴影方向。 |  
| enableReverse | `bool?` | `null` | 反转阴影方向。 |  


### 简单用法：视差 👀  

`TiltParallax` widget 只能在 `Tilt` widget 的 `childLayout` 中使用。  

```dart
/// 导入 flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

...
Tilt(
  childLayout: const ChildLayout(
    outer: [
      /// 此处为视差
      Positioned(
        child: TiltParallax(
          child: Text('Parallax'),
        ),
      ),
      /// 此处为视差
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
... 
```


#### `TiltParallax` widget 参数  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | 创建视差 widget。 |  
| size | `Offset` | `Offset(10.0, 10.0)` | 视差大小（像素单位）。 |  
| filterQuality | `FilterQuality` | `FilterQuality.high` | Flutter FilterQuality。 |  


## 许可证 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AmosHuKe/flutter_tilt/blob/main/LICENSE)  
根据 MIT 许可证开源。

© AmosHuKe

[在线示例]: https://amoshuke.github.io/flutter_tilt_book
[迁移指南]: https://github.com/AmosHuKe/flutter_tilt/blob/main/guides/migration_guide.md
