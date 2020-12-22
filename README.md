# Agora-Uniapp-SDK

此 SDK 基于 uni-app 以及 Agora Android 和 iOS 的视频 SDK 实现。

## 发版说明
[变更日志](CHANGELOG.md)

## 集成文档（离线打包）

### 克隆或下载本工程

`git clone https://github.com/AgoraIO-Community/Agora-Uniapp-SDK.git`

### 进入工程目录，执行 **install.sh** 脚本以下载 Agora iOS SDK

`cd Agora-Uniapp-SDK && sh ./install.sh`

并确保 **ios/libs** 目录中包含 **.framework** 文件

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
const AgoraRtcEngineModule = uni.requireNativePlugin('AgoraRtcEngineModule');
AgoraRtcEngineModule.callMethod({ method: string, args: {} }, (res) => {});
```

具体如何调用可以参考[src](src)中的 **.ts** 文件

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
