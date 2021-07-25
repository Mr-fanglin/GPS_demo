//
//  SNIMMsgAttachment.h
//  Sheng
//
//  Created by Fanglin on 2017/8/18.
//  Copyright © 2017年 Fanglin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

#define XCNIMMessageType @"type"     //类型KEY
#define XCNIMMessageData @"data"     //数据KEY
typedef NS_ENUM(NSInteger,XCNIMMsgType){     //自定义消息类型
    SNIMMsgTypeChildAskPick = 9,         ///小孩请求接送
    SNIMMsgTypeSendRequestPick = 10,     ///监护人发出接送请求
    SNIMMsgTypeHelpPick = 11,           ///帮忙接送
    SNIMMsgTypeAgreePick = 12,          ///同意某人接送
    SNIMMsgTypeOrderTips = 13,         ///订单状态提醒
    
    XCNIMMsgTypeAudioOrVideoCall = 30,   ///视频通话
    XCNIMMsgTypeAddFriendRequest = 31,   ///添加好友请求
    XCNIMMsgTypeAddFriendSuc = 32,       ///添加好友成功
};

@interface XCNIMChildAskPickAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, assign)NSInteger orderId;   //订单Id
@property (nonatomic, assign)NSInteger childId;
@property (nonatomic, copy)NSString *childName;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@end

@interface XCNIMSendRequestPickAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, assign)NSInteger orderId;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy)NSString *fromAddress;
@property (nonatomic, copy)NSString *toAddress;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, assign)double toLatitude;
@property (nonatomic, assign)double toLongitude;
@end

@interface XCNIMHelpPickAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, assign)NSInteger orderId;   //订单Id
@property (nonatomic, copy)NSString *childName;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@end

@interface XCNIMAgreePickAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, assign)NSInteger orderId;   //订单Id
@property (nonatomic, copy)NSString *driverName;
@property (nonatomic, assign)NSInteger driverId;
@end

@interface XCNIMOrderTipsAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, assign)NSInteger orderId;   //订单Id
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, copy)NSString *childName;
@property (nonatomic, assign)double lat;
@property (nonatomic, assign)double lng;
@end

@interface XCNIMAudioOrVideoCallAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, assign)NSInteger callType;   // 0 : 视频   1 : 音频
@end

@interface XCNIMAddFriendRequestAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, copy)NSString *attach;
@end

@interface XCNIMAddFriendSucAttachment : NSObject<NIMCustomAttachment>
@property (nonatomic, copy)NSString *message;
@end


