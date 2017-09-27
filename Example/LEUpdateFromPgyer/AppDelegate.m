//
//  AppDelegate.m
//  LEUpdateFromPgyer
//
//  Created by emerson larry on 2017/9/26.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "AppDelegate.h"

#import <LEUpdateFromPgyer/LEUpdateFromPgyer.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[LEUpdateFromPgyer sharedInstance] leAddPgySettings:
     @[
       [[LEPgySettings alloc] initWithTitle:@"官方测试包" Detail:@"新功能模块完整开发完成，供官方人员测试的版本" CanIgnoreUpdate:NO ApiKey:@"api" UKey:@"u" Password:@"psw"],
       [[LEPgySettings alloc] initWithTitle:@"开发测试包" Detail:@"不保证新功能模块已完整开发完成，供开发组内部测试的版本，提供永久忽略该更新的设置" CanIgnoreUpdate:YES ApiKey:@"api" UKey:@"u" Password:@"psw"],
       ].mutableCopy];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    NSString *pgy=[bundle objectForKey:@"PgyUpdate"];
    if(pgy&&[pgy boolValue]){
        NSLog(@"检测新版本(开发测试)...");
        [[LEUpdateFromPgyer sharedInstance] leCheckForNewVersion];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
