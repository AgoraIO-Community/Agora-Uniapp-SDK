# Agora-Uniapp-SDK

此 SDK 基于 uni-app 以及 Agora Android 和 iOS 的视频 SDK 实现。

## 发版说明
[变更日志](CHANGELOG.md)

## 集成文档（云打包）

需要同时引用以下两个插件，JS 插件主要是为了做代码提示，且包含一些JS的逻辑，便于开发者使用 Native 插件

[Native 插件](https://ext.dcloud.net.cn/plugin?id=3720)

[JS 插件](https://ext.dcloud.net.cn/plugin?id=3741)

## 集成文档（离线打包）

### 克隆或下载本工程，并进入工程目录

```shell
git clone https://github.com/AgoraIO-Community/Agora-Uniapp-SDK.git
cd Agora-Uniapp-SDK
```

### 安装依赖项并编译 JavaScript 脚本

```shell
yarn
```

随后拷贝 [lib/commonjs](lib/commonjs) 中生成的源代码到你的工程

**如果你的 uni-app 项目支持 TypeScript, 则直接拷贝 [src](https://github.com/AgoraIO-Community/Agora-Uniapp-SDK/tree/master/src) 内的源代码到你的工程即可**

### 执行 **install.sh** 脚本以下载 Agora iOS SDK

```shell
sh ./install.sh
```

并确认 **ios/libs** 目录中包含 **.framework** 文件

### 将 Android 和 iOS 工程分别放到 uni-app 离线 SDK 对应的目录中

* Android：**UniPlugin-Hello-AS**
* iOS：**HBuilder-uniPluginDemo**

### 将 Android 和 iOS 工程分别引入 uni-app 离线 SDK 工程

#### Android

* 在 **settings.gradle** 中添加
```
include ':uniplugin_agora_rtc'
project(':uniplugin_agora_rtc').projectDir = new File(rootProject.projectDir, 'android')
```

* 在 **app/build.gradle** 中添加 `implementation project(':uniplugin_agora_rtc')`

#### iOS

在 Xcode 中右键 **HBuilder-uniPlugin** 工程，并点击 **Add Files to "HBuilder-uniPlugin"**， 选中 **AgoraRtcUniPlugin.xcodeproj** 并添加

在 Xcode 中点击 **HBuilder-uniPlugin** 工程，并点击 **HBuilder** Target，选中 **Build Phases**

* 在 **Dependencies** 中添加 **AgoraRtcUniPlugin**
* 在 **Link Binary With Libraries** 中添加 **AgoraRtcUniPlugin.framework**
* 在 **Embed Frameworks** 中添加 **AgoraRtcKit.framework** **Agorafdkaac.framework** **Agoraffmpeg.framework** **AgoraSoundTouch.framework** （需要通过 **Add Other...** 选择 **ios/libs** 目录中的 **.framework** 文件添加）

## 如何使用

```javascript
// 指向插件JS源码在你的工程中的相对路径，比如
import RtcEngine from '../../components/Agora-RTC-JS/index';
RtcEngine.create('你的AppID').then((engine) => {
  console.log('init success');
});
```

**插件绝大部分 API 都使用 Promise 包装，为保证调用时序，请使用 await 关键字**

## 常见错误

## API文档

* [uni-app API](https://docs.agora.io/cn/Interactive%20Broadcast/API%20Reference/react_native/index.html)
* [Android API](https://docs.agora.io/cn/Interactive%20Broadcast/API%20Reference/java/index.html)
* [iOS API](https://docs.agora.io/cn/Interactive%20Broadcast/API%20Reference/oc/docs/headers/Agora-Objective-C-API-Overview.html)

## 资源

* 完整的 [API Doc](https://docs.agora.io/cn/) 在开发者中心
* [反馈问题](https://github.com/AgoraIO-Community/Agora-Uniapp-SDK/issues)
* [uni-app 原生插件](https://nativesupport.dcloud.net.cn/NativePlugin/README)

## 开源许可

MIT
