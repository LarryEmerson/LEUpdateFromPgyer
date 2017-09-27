# LEUpdateFromPgyer

[![Version](https://img.shields.io/cocoapods/v/LEUpdateFromPgyer.svg?style=flat)](http://cocoapods.org/pods/LEUpdateFromPgyer)
[![License](https://img.shields.io/cocoapods/l/LEUpdateFromPgyer.svg?style=flat)](http://cocoapods.org/pods/LEUpdateFromPgyer)
[![Platform](https://img.shields.io/cocoapods/p/LEUpdateFromPgyer.svg?style=flat)](http://cocoapods.org/pods/LEUpdateFromPgyer)
## 示例
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/v23_v24.jpg)
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/v24_v25.jpg)

## 如何使用
### 1.AutoBuildIpaAndUploadToPgyer使用环境部署：

```
[AutoBuildIpaAndUploadToPgyer](https://github.com/LarryEmerson/AutoBuildIpaAndUploadToPgyer)是自动打包的shell脚本，
可以添加工程路径，添加蒲公英账号，打包后自动上传到指定的蒲公英账号。
```

 - fastlane 安装： sudo gem install fastlane (也可以删除fastlane 直接运行gym)
 - 项目中确保Info.plist中的“Bundle versions string, short”为“1.0.0”的标准版本号，“Bundle version”为“1”整形
 - BuildPhases中添加新的Shell
 
 ```
 buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
 buildNumber=$(($buildNumber + 1))
 /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"
 ``` 
 - 上传后的第一个版本建议进入蒲公英网页设置”Build 版本号设置“为”使用App本身的Build版本号“
### 2. LEUpdateFromPgyer引入方式：
 - pod 引入 #import <LEUpdateFromPgyer/LEUpdateFromPgyer.h>
  
  ```
  use_frameworks!
  target 'xxx' do
    pod 'LEUpdateFromPgyer'
  end
  ```
  
 - 直接拖动LEUpdateFromPgyer文件夹到工程 #import "LEUpdateFromPgyer.h"
### 3.接口接入
 - APPDelegate中 添加蒲公英账号apiKey,uKey,password及更新弹窗的提示标题，详细说明，是否允许永久忽略
   
   ```
   [[LEUpdateFromPgyer sharedInstance] leAddPgySettings:
     @[
       [[LEPgySettings alloc] initWithTitle:@"官方测试包" Detail:@"新功能模块完整开发完成，供官方人员测试的版本" CanIgnoreUpdate:NO ApiKey:@"api" UKey:@"u" Password:@"psw"],
       [[LEPgySettings alloc] initWithTitle:@"开发测试包" Detail:@"不保证新功能模块已完整开发完成，供开发组内部测试的版本，提供永久忽略该更新的设置" CanIgnoreUpdate:YES ApiKey:@"api" UKey:@"u" Password:@"psw"],
       ].mutableCopy];
   ```
   
 - 应用激活后
  
  ```
  - (void)applicationDidBecomeActive:(UIApplication *)application { 
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    NSString *pgy=[bundle objectForKey:@"PgyUpdate"];
    if(pgy&&[pgy boolValue]){
        NSLog(@"检测新版本(开发测试)...");
        [[LEUpdateFromPgyer sharedInstance] leCheckForNewVersion];
    }
  }
  ```

## Author

larryemerson@163.com

## License

LEUpdateFromPgyer is available under the MIT license. See the LICENSE file for more info.


