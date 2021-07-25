//
//  NIMKit.m
//  NIMKit
//
//  Created by amao on 8/14/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "NIMKit.h"
//#import "NIMKitTimerHolder.h"
//#import "NIMKitNotificationFirer.h"
#import "NIMKitDataProviderImpl.h"

#import "NIMKitInfoFetchOption.h"
#import "NSBundle+NIMKit.h"
#import "NSString+NIMKit.h"
//#import "NIMChatUIManager.h"

extern NSString *const NIMKitUserInfoHasUpdatedNotification;
extern NSString *const NIMKitTeamInfoHasUpdatedNotification;


@interface NIMKit(){
    NSRegularExpression *_urlRegex;
}

@end


@implementation NIMKit
- (instancetype)init
{
    if (self = [super init]) {
        _provider = [[NIMKitDataProviderImpl alloc] init];   //默认使用 NIMKit 的实现
        [self preloadNIMKitBundleResource];
    }
    return self;
}

+ (instancetype)sharedKit
{
    static NIMKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMKit alloc] init];
    });
    return instance;
}

- (void)notfiyUserInfoChanged:(NSArray *)userIds{
    if (!userIds.count) {
        return;
    }
    for (NSString *userId in userIds) {
//        NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
//        NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
//        info.session = session;
//        info.notificationName = NIMKitUserInfoHasUpdatedNotification;
//        [self.firer addFireInfo:info];
    }
}

- (void)notifyTeamInfoChanged:(NSString *)teamId type:(NIMKitTeamType)type
{
//    NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
//    if (teamId.length) {
//        NIMSession *session = nil;
//        if (type == NIMKitTeamTypeNomal) {
//            session = [NIMSession session:teamId type:NIMSessionTypeTeam];
//        } else if (type == NIMKitTeamTypeSuper) {
//            session = [NIMSession session:teamId type:NIMSessionTypeSuperTeam];
//        }
//        info.session = session;
//    }
//    info.notificationName = NIMKitTeamInfoHasUpdatedNotification;
//    [self.firer addFireInfo:info];
}

- (void)notifyTeamMemebersChanged:(NSString *)teamId type:(NIMKitTeamType)type
{
//    NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
//    if (teamId.length) {
//        NIMSession *session = nil;
//        if (type == NIMKitTeamTypeNomal) {
//            session = [NIMSession session:teamId type:NIMSessionTypeTeam];
//        } else if (type == NIMKitTeamTypeSuper) {
//            session = [NIMSession session:teamId type:NIMSessionTypeSuperTeam];
//        }
//        info.session = session;
//    }
//    extern NSString *NIMKitTeamMembersHasUpdatedNotification;
//    info.notificationName = NIMKitTeamMembersHasUpdatedNotification;
//    [self.firer addFireInfo:info];
}
- (NIMKitInfo *)infoByUser:(NSString *)userId option:(NIMKitInfoFetchOption *)option
{
    NIMKitInfo *info = nil;
    if (self.provider && [self.provider respondsToSelector:@selector(infoByUser:option:)]) {
        info = [self.provider infoByUser:userId option:option];
    }
    return info;
}

- (void)preloadNIMKitBundleResource {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NIMInputEmoticonManager sharedManager] start];
//    });
}

- (NSString *)replyedContentWithMessage:(NIMMessage *)message
{
    NSString *info = nil;

    if (!message)
    {
        return @"\"未知消息\"".nim_localized;
    }
    
//    if (self.provider && [self.provider respondsToSelector:@selector(replyedContentWithMessage:)]) {
//        info = [self.provider replyedContentWithMessage:message];
//    }
    return info;
}

@end



