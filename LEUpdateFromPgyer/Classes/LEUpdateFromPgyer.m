//
//  LEUpdateFromPgyer.m
//
//
//  Created by emerson larry on 2017/9/23.
//  Copyright © 2017年 LarryEmerson. All rights reserved.
//

#import "LEUpdateFromPgyer.h"
@implementation LEPgySettings
-(instancetype) initWithTitle:(NSString *) title Detail:(NSString *) detail CanIgnoreUpdate:(BOOL) ignore ApiKey:(NSString *) api UKey:(NSString *) ukey Password:(NSString *) psw{
    self=[super init];
    self.title=title;
    self.detail=detail;
    self.canIgnore=ignore;
    self.apiKey=api;
    self.uKey=ukey;
    self.password=psw;
    return self;
}
@end

@interface LEUpdateFromPgyer()<UIActionSheetDelegate>
@end
@implementation LEUpdateFromPgyer{
    NSUserDefaults *userDefaults;
    NSString *bundleIdentifier;
    NSString *version;
    int build;
    //Pgyer
    NSMutableArray *pgySettings;
    UIActionSheet *sheet;
    LEPgySettings *targetPgy;
}
Singleton_implementation(LEUpdateFromPgyer)
-(void) leAddPgySettings:(NSMutableArray *) settings{
    pgySettings=settings;
}
-(void) leAdditionalInits{
    userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    bundleIdentifier=[bundle objectForKey:@"CFBundleIdentifier"];
    version=[bundle objectForKey:@"CFBundleShortVersionString"];
    build=[[bundle objectForKey:@"CFBundleVersion"] intValue];
}
-(void) leCheckForNewVersion{
    
    if(pgySettings&&pgySettings.count>0){
        for (NSInteger index=0; index<pgySettings.count; index++) {
            LEPgySettings *pgy=[pgySettings objectAtIndex:index];
            pgy.buildVersion=nil;
            pgy.isSet=NO;
            NSURL *URL=[NSURL URLWithString:@"https://www.pgyer.com/apiv2/app/listMy"];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
            request.HTTPMethod=@"POST";
            NSString *param=[NSString stringWithFormat:@"_api_key=%@",pgy.apiKey];
            request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                if(dict){
                    NSDictionary *data=[dict objectForKey:@"data"];
                    if(data&&[data isKindOfClass:[NSDictionary class]]){
                        NSArray *list=[data objectForKey:@"list"];
                        if(list.count>0){
                            for (NSInteger i=0; i<list.count; i++) {
                                NSDictionary *app=[list objectAtIndex:i];
                                if([[app objectForKey:@"buildIdentifier"] isEqualToString:bundleIdentifier]&&[[app objectForKey:@"buildType"] intValue] == 1){
                                    pgy.buildKey=[app objectForKey:@"buildKey"];
                                    pgy.buildShortcutUrl=[app objectForKey:@"buildShortcutUrl"];
                                    if(![userDefaults objectForKey:pgy.buildShortcutUrl]||![[userDefaults objectForKey:pgy.buildShortcutUrl] boolValue]){
                                        NSString *buildVersion=[app objectForKey:@"buildVersion"];
                                        int buildVersionNo=[[app objectForKey:@"buildVersionNo"] intValue];
                                        if(pgy.buildVersion){
                                            if(compareVersion([buildVersion UTF8String], [version UTF8String]) || ([version isEqualToString: buildVersion] && buildVersionNo > build)){
                                                pgy.buildVersion=buildVersion;
                                                pgy.buildVersionNo=buildVersionNo;
                                            }
                                        }else{
                                            pgy.buildVersion=buildVersion;
                                            pgy.buildVersionNo=buildVersionNo;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                pgy.isSet=YES;
                [self showSheet];
            }];
            [sessionDataTask resume];
        }
    }
}
-(void) showSheet{
    targetPgy=nil;
    for (NSInteger index=0; index<pgySettings.count; ++index) {
        LEPgySettings *pgy=[pgySettings objectAtIndex:index];
        if(!pgy.isSet){
            return;
        }
        if(pgy.buildVersion){
            if(targetPgy){
                if(compareVersion([pgy.buildVersion UTF8String], [targetPgy.buildVersion UTF8String]) > 0 || ([targetPgy.buildVersion isEqualToString: pgy.buildVersion] && pgy.buildVersionNo > targetPgy.buildVersionNo)){
                    targetPgy=pgy;
                }
            }else {
                targetPgy=pgy;
            }
        }
    }
    if(targetPgy){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(compareVersion([targetPgy.buildVersion UTF8String], [version UTF8String]) > 0 || ([targetPgy.buildVersion isEqualToString: version] && targetPgy.buildVersionNo > build)){
                sheet=[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@\n%@(%d)->%@(%d)\n%@",targetPgy.title,version,build,targetPgy.buildVersion,targetPgy.buildVersionNo, targetPgy.detail] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:targetPgy.canIgnore?@"永久忽略":nil otherButtonTitles:@"更新", nil];
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            }
        });
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    if(buttonIndex==sheet.firstOtherButtonIndex){
        NSString *url=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/%@",targetPgy.buildKey];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else if(buttonIndex==sheet.destructiveButtonIndex){
        [userDefaults setObject:@(YES) forKey:targetPgy.buildShortcutUrl];
    }
}

/**
 * 比较版本号
 *
 * @param v1 第一个版本号
 * @param v2 第二个版本号
 *
 * @return 如果版本号相等，返回 0,
 *         如果第一个版本号低于第二个，返回 -1，否则返回 1.
 */
int compareVersion(const char *v1, const char *v2){
    assert(v1);
    assert(v2);
    const char *p_v1 = v1;
    const char *p_v2 = v2;
    while (*p_v1 && *p_v2) {
        char buf_v1[32] = {0};
        char buf_v2[32] = {0};
        char *i_v1 = strchr(p_v1, '.');
        char *i_v2 = strchr(p_v2, '.');
        if (!i_v1 || !i_v2) break;
        if (i_v1 != p_v1) {
            strncpy(buf_v1, p_v1, i_v1 - p_v1);
            p_v1 = i_v1;
        }
        else
            p_v1++;
        if (i_v2 != p_v2) {
            strncpy(buf_v2, p_v2, i_v2 - p_v2);
            p_v2 = i_v2;
        }
        else
            p_v2++;
        int order = atoi(buf_v1) - atoi(buf_v2);
        if (order != 0)
            return order < 0 ? -1 : 1;
    }
    double res = atof(p_v1) - atof(p_v2);
    if (res < 0) return -1;
    if (res > 0) return 1;
    return 0;
}
@end
