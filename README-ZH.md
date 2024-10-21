[![GitHub stars](https://img.shields.io/github/stars/fluttercandies/flutter_tilt?style=social&logo=github&logoColor=1F2328&label=stars)](https://github.com/fluttercandies/flutter_tilt)
[![Pub.dev likes](https://img.shields.io/pub/likes/flutter_tilt?style=social&logo=flutter&logoColor=168AFD&label=likes)](https://pub.dev/packages/flutter_tilt)

📓 语言：[English](README.md) | 中文  
🎁 查看：[在线示例][]  
💡 查看：[迁移指南][] 了解如何从破坏性改动中迁移为可用代码  

<br/><br/>

<h1 align="center">Flutter Tilt</h1>

<p align="center">
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=%E7%A8%B3%E5%AE%9A%E7%89%88&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/pub/v/flutter_tilt?color=3e4663&label=%E5%BC%80%E5%8F%91%E7%89%88&logo=flutter&include_prereleases" alt="dev package" /></a>
  <a href="https://pub.dev/packages/flutter_tilt/score"><img src="https://img.shields.io/pub/points/flutter_tilt?color=2E8B57&label=%E5%88%86%E6%95%B0&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/fluttercandies/flutter_tilt"><img src="https://img.shields.io/codefactor/grade/github/fluttercandies/flutter_tilt?color=0CAB6B&label=%E4%BB%A3%E7%A0%81%E8%B4%A8%E9%87%8F&logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://codecov.io/gh/fluttercandies/flutter_tilt"><img src="https://img.shields.io/codecov/c/github/fluttercandies/flutter_tilt?label=%E6%B5%8B%E8%AF%95%E8%A6%86%E7%9B%96&logo=codecov" alt="codecov" /></a>
  <a href="https://pub.dev/packages/flutter_tilt"><img src="https://img.shields.io/github/languages/top/fluttercandies/flutter_tilt?color=00B4AB" alt="top language" /></a>
</p>

<p align="center">
  <strong >在 Flutter 上轻松创建倾斜视差悬停效果！</strong>
</p>

<br/>

<div align="center">
  <table width="620" align="center" border="0">
    <tr>
      <td align="right">
        <img width="285px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview2-small.gif" alt="Example Preview GIF - Parallax image" /><br/><img width="285px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview-small.gif" alt="Example Preview GIF" />
      </td>
      <td align="left">
        <img width="320px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview4-small.gif" alt="Example Preview GIF - Parallax card" /><br/><img width="320px" src="https://raw.githubusercontent.com/fluttercandies/flutter_tilt/main/README/preview3-small.gif" alt="Example Preview GIF - Layout" />
      </td>
    </tr>
    <tr>
      <td align="center" colspan="2">

查看 [在线示例][]
      </td>
    </tr>
  </table>
</div>

<br/>

## 目录 🪄

<sub>

- [特性](#特性-)

- [安装](#安装-)

  - [版本兼容](#版本兼容-)

  - [平台兼容](#平台兼容-)

  - [添加 flutter_tilt](#添加-flutter_tilt-)

- [传感器兼容][]

- [手势优先级](#手势优先级-)

- [简单用法](#简单用法-)

  - [倾斜](#倾斜-)

  - [视差](#视差-)

- [使用](#使用-)

  - [Tilt widget 参数][]

  - [TiltParallax widget 参数][]

  - [ChildLayout][]

  - [StreamController&lt;TiltStreamModel&gt;][]

  - [TiltConfig][]

  - [LightShadowMode][]

  - [LightConfig][]

  - [ShadowConfig][]

- [贡献者](#贡献者-)

- [许可证](#许可证-)

</sub>

<br/>


## 特性 ✨  

- 📦 倾斜效果
- 🔦 光照效果
- 💡 阴影效果
- 👀 视差效果
- 📱 陀螺仪传感器支持（[传感器兼容][]）
- 🧱 多种布局位置
- 👇 支持鼠标、触摸和传感器事件
- 🖼️ 流畅的动画
- ⚙️ 许多自定义参数


## 安装 🎯
### 版本兼容 🐦  

|       Flutter       |  3.0.0+  |  3.10.0+  |  3.19.0+  |  
|      ---------      | :------: | :-------: | :-------: |  
| flutter_tilt 3.0.0+ |    ❌    |    ❌    |    ✅    |  
| flutter_tilt 2.0.0+ |    ❌    |    ✅    |    ✅    |  
| flutter_tilt 1.0.0+ |    ✅    |    ❌    |    ❌    |  


### 平台兼容 📱  

| Android |  iOS  |  Web  | macOS | Windows | Linux |  
| :-----: | :---: | :---: | :---: | :-----: | :---: |  
|   ✅   |   ✅  |  ✅   |  ✅  |   ✅   |  ✅   |  


### 添加 flutter_tilt 📦  

使用 Flutter 运行以下指令，  

```sh
$ flutter pub add flutter_tilt
```

或手动将 `flutter_tilt` 添加到 `pubspec.yaml` 依赖项中。  

```yaml
dependencies:
  flutter_tilt: ^最新版本
```


## 传感器兼容 📱  

传感器仅在以下平台触发。  
不支持传感器的平台不会影响其他功能的正常使用。  

| Android |  iOS  |                 Web (HTTPS)                  | macOS | Windows | Linux |  
| :-----: | :---: | :------------------------------------------: | :---: | :-----: | :---: |  
|   ✅   |   ✅  | [浏览器兼容][Gyroscope Browser compatibility] |  ❌  |   ❌    |  ❌  |  

> [!NOTE]  
> 目前 Web 使用 [Sensor API - Gyroscope][]，但它不兼容部分主流浏览器，比如 Safari、Firefox。  
<!-- > 之后也许会替换为 [DeviceMotionEvent][]。 -->


## 手势优先级 📱

启用多个手势时，会按照优先级触发手势：

> Touch > Hover > Controller > Sensors


## 简单用法 📖  

示例：[flutter_tilt/example][]


### 倾斜 📦  

[Tilt][Tilt widget 参数] widget 默认有倾斜、阴影和光照的效果。  

```dart
/// 导入 flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

Tilt(
  child: Container(
    width: 150.0,
    height: 300.0,
    color: Colors.grey,
  ),
),

```


### 视差 👀  

[TiltParallax][TiltParallax widget 参数] widget 只能在 `Tilt` widget 的 `childLayout` 中使用。  

```dart
/// 导入 flutter_tilt
import 'package:flutter_tilt/flutter_tilt.dart';

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

```


## 使用 📖  
### `Tilt` widget 参数 🤖  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | 创建一个 widget，使 child widget 有倾斜效果。 |  
| childLayout | [ChildLayout][] | `ChildLayout()` | 其它 child 布局。 <br/> 例如：位于 child 外部、内部、后面的视差布局。 |  
| tiltStreamController | [StreamController&lt;TiltStreamModel&gt;][]? | `null` | 使用 `StreamController<TiltStreamModel>.broadcast()` 来自定义控制倾斜。 |  
| disable | `bool` | `false` | 禁用所有效果。 |  
| fps | `int` | `60` | 手势触发的帧数。 |  
| border | `BoxBorder?` | `null` | BoxDecoration border。 |  
| borderRadius | `BorderRadiusGeometry?` | `null` | BoxDecoration borderRadius。 |  
| clipBehavior | `Clip` | `Clip.antiAlias` | Flutter 中的 clipBehavior。 |  
| tiltConfig | [TiltConfig][] | `TiltConfig()` | 倾斜效果配置。 |  
| lightShadowMode | [LightShadowMode][] | `LightShadowMode.base` | 光影 Mode。 |  
| lightConfig | [LightConfig][] | `LightConfig()` | 光照效果配置。 |  
| shadowConfig | [ShadowConfig][] | `ShadowConfig()` | 阴影效果配置。 |  
| onGestureMove | `void Function(TiltDataModel, GesturesType)?` | `null` | 手势移动的回调触发。 |  
| onGestureLeave | `void Function(TiltDataModel, GesturesType)?` | `null` | 手势离开的回调触发。 |  


### `TiltParallax` widget 参数 🤖  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | 创建视差 widget。 |  
| size | `Offset` | `Offset(10.0, 10.0)` | 视差大小。 |  
| filterQuality | `FilterQuality` | `null` | Flutter FilterQuality。 |  


### ChildLayout 📄  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| outer | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 外部` 的 widget。 <br/> 例如：视差效果。 |  
| inner | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 内部` 的 widget。 <br/> 例如：视差效果。 |  
| behind | `List<Widget>` | `<Widget>[]` | 与 Stack 一样，你可以使用 Stack 布局来创建一些位于 `child 后面` 的 widget。 <br/> 例如：视差效果。 |  


### StreamController&lt;TiltStreamModel&gt; 📄

```dart

final StreamController<TiltStreamModel> tiltStreamController =
      StreamController<TiltStreamModel>.broadcast();

/// 正在使用当前手势
tiltStreamController.add(
  TiltStreamModel(
    position: Offset(xx, xx),
  ),
);

/// 停止使用当前手势
tiltStreamController.add(
  TiltStreamModel(
    position: Offset(xx, xx),
    gestureUse: false,
  ),
);

```

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| position <sup>`required`</sup> | `Offset` | - | 当前触发的坐标位置， <br/> 会触发对应位置的倾斜效果。 <br/> 例如： <br/> 有一个组件尺寸为 width: 10, height: 10, <br/> (0, 0)：会触发最左上的倾斜。 <br/> (10, 10)：会触发最右下的倾斜。 |  
| gesturesType | `GesturesType` | `GesturesType.controller` | 触发手势类型。 <br/> 会根据 [手势优先级](#手势优先级-) 进行触发。 <br/> 如果需要自定义动画或其他方式自行控制， <br/> `推荐` 使用 `GesturesType.controller`。 <br/> 如果使用其他的类型进行触发， <br/> 那么就会受到对应类型相关配置、效果的影响。 <br/> 例如： <br/> 自行触发 `GesturesType.sensors` 的时候。 <br/> 配置 `TiltConfig.enableSensorRevert` 为 false 的情况下， <br/> 将同样不会复原至初始状态。 |  
| gestureUse | `bool` | `true` | 手势是否正在使用。 <br/> 用于确定手势是否正在使用，并根据手势优先级进行处理。 <br/> 例如： <br/> 如果在触发 `GesturesType.touch` 的时候永远不赋值为 false，那么优先级低于 `GesturesType.touch` 的手势将永远不会被触发。 |  


### TiltConfig 📄  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用倾斜效果。 |  
| initial | `Offset?` | `null` | 倾斜进度的初始值，范围 `(x, y)：(1, 1) 至 (-1, -1)`，<br/> 你可以超过这个范围，但是手势移动过程中的最大倾斜角度始终按照 `[TiltConfig.angle]` 进行倾斜。 <br/> 例如：(0.0, 0.0) 中心 <br/> (1.0, 1.0) 左上角最大倾斜角度 `[TiltConfig.angle]`。 |  
| angle | `double` | `10.0` | 最大倾斜角度。 <br/> 例如：180 会翻转。 |  
| direction | `List<TiltDirection>?` | `null` | 倾斜方向，多方向、自定义方向值。 |  
| enableReverse | `bool` | `false` | 倾斜反向，可以向上或向下倾斜。 |  
| filterQuality | `FilterQuality` | `null` | Flutter FilterQuality。 |  
| enableGestureSensors | `bool` | `true` | 陀螺仪传感器触发倾斜。 <br/> 仅以下手势生效： <br/> `GesturesType.sensors` |  
| sensorFactor | `double` | `10.0` | 传感器触发系数（灵敏度）。 <br/> 仅以下手势生效： <br/> `GesturesType.sensors` |  
| enableSensorRevert | `bool` | `true` | 启用传感器倾斜复原，会复原至初始状态。 <br/> 仅以下手势生效： <br/> `GesturesType.sensors` |  
| sensorRevertFactor | `double` | `0.05` | 传感器复原系数（阻尼），数值范围：`0-1`。 <br/> 仅以下手势生效： <br/> `GesturesType.sensors` |  
| sensorMoveDuration | `Duration` | `Duration(milliseconds: 50)` | 传感器移动时的动画持续时间。 <br/> 仅以下手势生效： <br/> `GesturesType.sensors` |  
| enableGestureHover | `bool` | `true` | Hover 手势触发倾斜。 <br/> 仅以下手势生效： <br/> `GesturesType.hover` |  
| enableGestureTouch | `bool` | `true` | Touch 手势触发倾斜。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` |  
| enableRevert | `bool` | `true` | 启用倾斜复原，会复原至初始状态。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.hover` <br/> `GesturesType.controller` |  
| enableOutsideAreaMove | `bool` | `true` | 可以继续在区域外触发倾斜。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.controller` |  
| moveDuration | `Duration` | `Duration(milliseconds: 100)` | 手势移动时的动画持续时间。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| leaveDuration | `Duration` | `Duration(milliseconds: 300)` | 手势离开后的动画持续时间。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| moveCurve | `Curve` | `Curves.linear` | 手势移动时的动画曲线。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| leaveCurve | `Curve` | `Curves.linear` | 手势离开后的动画曲线。 <br/> 仅以下手势生效： <br/> `GesturesType.touch` <br/> `GesturesType.hover` |  
| controllerMoveDuration | `Duration` | `Duration(milliseconds: 100)` | controller 手势移动时的动画持续时间。 <br/> 仅以下手势生效： <br/> `GesturesType.controller` |  
| controllerLeaveDuration | `Duration` | `Duration(milliseconds: 300)` | controller 手势离开后的动画持续时间。 <br/> 仅以下手势生效： <br/> `GesturesType.controller` |  


### LightShadowMode 📄

| 枚举值 | 描述 |  
| --- | --- |
| LightShadowMode.base | `[无性能风险]` <br/> 仅对 `Tilt.child` 使用普通阴影效果，无性能损耗。 |  
| LightShadowMode.projector | `[有性能风险]` <br/> 对整个 `Tilt` widget 使用类似投影仪效果的阴影，<br/> 会显示与 widget 非透明部分完全一致的阴影。 <br/> 建议在以下场景使用：<br/> - 仅图片 <br/> - 无数据状态 <br/> - 无 Hero 标签 |  


### LightConfig 📄  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用光照效果。 |  
| color | `Color` | `Color(0xFFFFFFFF)` | 光照颜色。 |  
| minIntensity | `double` | `0.0` | 颜色最小不透明度，也是初始不透明度。 |  
| maxIntensity | `double` | `0.5` | 颜色最大不透明度，跟随倾斜最大进度。 |  
| spreadFactor | `double` | `4.0` | 光源扩散系数，相对于当前 widget 尺寸。 |  
| projectorScale | `double` | `1.1` | 光照区域尺寸比例。 <br/> 仅以下模式生效：<br/> `[LightShadowMode.projector]` |  
| direction | `LightDirection` | `LightDirection.around` | 光照方向。 <br/> 影响：<br/> `[ShadowConfig.direction]`（配置后不受影响）。 |  
| enableReverse | `bool` | `false` | 反转光照方向。 <br/> 影响：<br/> `[ShadowConfig.direction]`（配置后不受影响）。 <br/> `[ShadowConfig.enableReverse]`（配置后不受影响）。 |  


### ShadowConfig 📄  

| 参数名 | 类型 | 默认值 | 描述 |  
| --- | --- | --- | --- |
| disable | `bool` | `false` | 仅禁用阴影效果。 |  
| color | `Color` | `Color(0xFF9E9E9E)` | 阴影颜色。 |  
| minIntensity | `double` | `0.0` | 颜色最小不透明度，也是初始不透明度。 |  
| maxIntensity | `double` | `0.5` | 颜色最大不透明度，跟随倾斜最大进度。 |  
| offsetInitial | `Offset` | `Offset(0.0, 0.0)` | 阴影偏移初始值。 <br/> 例如：(0.0, 0.0) 中心 <br/> (40.0, 40.0) 向左上角偏移 40。 |  
| offsetFactor | `double` | `0.1` | 阴影偏移系数，相对于当前 widget 尺寸。 |  
| spreadInitial | `double` | `0.0` | 阴影扩散半径初始值。<br/> 仅以下模式生效：<br/> `[LightShadowMode.base]` |  
| spreadFactor | `double` | `0.0` | 阴影扩散半径系数，相对于当前 widget 尺寸。<br/> 仅以下模式生效：<br/> `[LightShadowMode.base]` |  
| minBlurRadius | `double` | `10.0` | 最小阴影模糊半径，也是初始模糊半径。<br/> 仅以下模式生效：<br/> `[LightShadowMode.base]` |  
| maxBlurRadius | `double` | `20.0` | 最大阴影模糊半径，跟随倾斜最大进度。<br/> 仅以下模式生效：<br/> `[LightShadowMode.base]` |  
| projectorScaleFrom | `double` | `1.0` | 最小倾斜进度的阴影尺寸比例，也是初始尺寸比例。<br/> 仅以下模式生效：<br/> `[LightShadowMode.projector]` |  
| projectorScaleTo | `double` | `1.0` | 最大倾斜进度的阴影尺寸比例。 <br/> 仅以下模式生效：<br/> `[LightShadowMode.projector]` |  
| projectorBlurSigmaFrom | `double` | `5.0` | 最小倾斜进度的阴影模糊 Sigma，也是初始模糊 Sigma。<br/> 仅以下模式生效：<br/> `[LightShadowMode.projector]` |  
| projectorBlurSigmaTo | `double` | `10.0` | 最大倾斜进度的阴影模糊 Sigma。<br/> 仅以下模式生效：<br/> `[LightShadowMode.projector]` |  
| direction | `ShadowDirection?` | `null` | 阴影方向。 |  
| enableReverse | `bool?` | `null` | 反转阴影方向。 |  


## 贡献者 ✨  

更多详情，请查看 [graphs/contributors](https://github.com/fluttercandies/flutter_tilt/graphs/contributors)。  
欢迎任何形式的的贡献！ ([emoji key](https://allcontributors.org/docs/en/emoji-key))  

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
    </tr>
  <tbody>
</table>


## 许可证 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/fluttercandies/flutter_tilt/blob/main/LICENSE)  
根据 MIT 许可证开源。

© AmosHuKe

[在线示例]: https://amoshuke.github.io/flutter_tilt_book
[迁移指南]: https://github.com/fluttercandies/flutter_tilt/blob/main/guides/migration_guide.md
[flutter_tilt/example]: https://github.com/fluttercandies/flutter_tilt/tree/main/example
[传感器兼容]: #传感器兼容-
[Tilt widget 参数]: #tilt-widget-参数-
[TiltParallax widget 参数]: #tiltparallax-widget-参数-
[ChildLayout]: #childlayout-
[StreamController&lt;TiltStreamModel&gt;]: #streamcontrollertiltstreammodel-
[TiltConfig]: #tiltconfig-
[LightShadowMode]: #lightshadowmode-
[LightConfig]: #lightconfig-
[ShadowConfig]: #shadowconfig-
[Gyroscope Browser compatibility]: https://developer.mozilla.org/en-US/docs/Web/API/Sensor_APIs#api.gyroscope
[Sensor API - Gyroscope]: https://developer.mozilla.org/en-US/docs/Web/API/Gyroscope
<!-- [DeviceMotionEvent]: https://developer.mozilla.org/zh-CN/docs/Web/API/DeviceMotionEvent -->
