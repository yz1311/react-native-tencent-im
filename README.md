
# rn-tencent-im

[![npm version](http://img.shields.io/npm/v/rn-tencent-im.svg?style=flat-square)](https://npmjs.org/package/rn-tencent-im "View this project on npm")
[![npm version](http://img.shields.io/npm/dm/rn-tencent-im.svg?style=flat-square)](https://npmjs.org/package/rn-tencent-im "View this project on npm")

bugly for react-native,支持统计，android支持应用全量升级

## 安装

> `$ npm install rn-tencent-im --save`

* react-native <0.60

> `$ react-native link rn-tencent-im`

* react-native >=0.60

新版RN会自动link,不需要执行link命令

---
不管是哪个版本的react-native，ios端都需要在`ios`文件夹下执行
```shell
$ cd ios
$ pod install
```


### 配置
#### iOS
`AppDelegate.m`
```
#import "RNBugly.h"
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  //初始化bugly，会自动读取info.plist中的参数
  [RNBugly startWithAppId];
  return YES;
}
```
`info.plist`文件读取SDK初始化参数，可配置的参数如下(`除Appid为必填外，其它可选`)：
```
- Appid
    - Key: BuglyAppIDString
    - Value: 字符串类型
- 渠道标识
    - Key: BuglyAppChannelString
    - Value: 字符串类型
- 版本信息
    - Key: BuglyAppVersionString
    - Value: 字符串类型
- 开启Debug信息显示
    - Key: BuglyDebugEnable
    - Value: BOOL类型
```

#### Android
`MainApplication.java`(依旧可以用Bugly.init进行初始化，下面两个方法只是对Bugly.init的简单封装)
```
import com.reactlibrary.bugly.RNBuglyModule;

@Override
public void onCreate() {
  super.onCreate();

  ...

 
}
```

## 使用
```javascript
import RNBugly from 'rn-tencent-im';

```

bugly后端异常信息如下：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gpdin9v721j30ww04imxk.jpg)
<br/>
<br/>
![](https://tva1.sinaimg.cn/large/008eGmZEgy1gpdiomwgs7j30w6068aal.jpg)

其他方法及注释请查看: [index.d.ts](types/index.d.ts)

参考[demo](./example),或者下载[example.apk](https://zhaoyang.lanzous.com/ib832sh)体验



## 注意事项&&疑问

#### 1.无法使用?

请升级到最新版本后再试

目前对于React Native不用区分版本，直接使用最新版即可,只是安装方式略有不同

#### 2.<font color='red'>集成后全量更新无效果</font>

请确定targetSDKVersion是否为28或者以上，bugly请求由于使用了http，而android 9默认是不支持http请求的，需要调整下

具体请参考:

https://blog.csdn.net/weixin_34114823/article/details/88037177

在最新的1.1.0的版本中，依赖的官方sdk，已经支持https了，具体查看[官方日志](https://bugly.qq.com/docs/release-notes/release-android-beta/?v=20200622202242)



#### 3.为什么我点击更新按钮后，对话框关闭，啥反应都没有?

等一会会出现安装提示,bugly对的更新方式是直接在通知栏显示下载进度，下载完成覆盖安装，如果状态栏没有提示，那就是没有通知权限(oppo/vivo系统是默认不开启该权限的)
  
## 截图

