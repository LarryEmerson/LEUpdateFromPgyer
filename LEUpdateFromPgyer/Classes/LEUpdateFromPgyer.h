//
//  LEUpdateFromPgyer.h
//  
//
//  Created by emerson larry on 2017/9/23.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <LEFoundation/LEFoundation.h>

#define Singleton_interface(className) \
+ (className *)sharedInstance;

#define Singleton_implementation(className) \
static id _instace = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
} \
return _instace; \
} \
\
- (instancetype)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super init]; \
[_instace leAdditionalInits];\
}); \
return _instace; \
} \
\
+ (instancetype)sharedInstance \
{ \
return [[self alloc] init]; \
} \
+ (instancetype)copyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
} \
\
+ (instancetype)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
}

@interface LEPgySettings :NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) BOOL canIgnore;
@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *uKey;
@property (nonatomic) NSString *password;
//
@property (nonatomic) NSString *buildKey;
@property (nonatomic) NSString *buildShortcutUrl;
@property (nonatomic) NSString *buildVersion;
@property (nonatomic) int buildVersionNo;
@property (nonatomic) BOOL isSet;
-(instancetype) initWithTitle:(NSString *) title Detail:(NSString *) detail CanIgnoreUpdate:(BOOL) ignore ApiKey:(NSString *) api UKey:(NSString *) ukey Password:(NSString *) psw;
@end
@interface LEUpdateFromPgyer : NSObject
Singleton_interface(LEUpdateFromPgyer)
-(void) leAddPgySettings:(NSMutableArray *) settings;
-(void) leCheckForNewVersion;
@end

