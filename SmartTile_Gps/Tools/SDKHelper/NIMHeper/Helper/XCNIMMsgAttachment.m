//
//  SNIMMsgAttachment.m
//  Sheng
//
//  Created by Fanglin on 2017/8/18.
//  Copyright © 2017年 Fanglin. All rights reserved.
//

#import "XCNIMMsgAttachment.h"
#import "NSDictionary+NTESJson.h"

@implementation XCNIMChildAskPickAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(SNIMMsgTypeChildAskPick), XCNIMMessageData:@{@"orderId":@(self.orderId),@"childId":@(self.childId),@"latitude":@(self.latitude),@"longitude":@(self.longitude),@"childName":self.childName}};
    return [dic jsonBody];
}
@end

@implementation XCNIMSendRequestPickAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(SNIMMsgTypeSendRequestPick), XCNIMMessageData:@{@"orderId":@(self.orderId),@"userId":@(self.userId),@"latitude":@(self.latitude),@"longitude":@(self.longitude),@"toLatitude":@(self.toLatitude),@"toLongitude":@(self.toLongitude),@"fromAddress":self.fromAddress,@"toAddress":self.toAddress,@"userName":self.userName}};
    return [dic jsonBody];
}
@end

@implementation XCNIMHelpPickAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(SNIMMsgTypeHelpPick), XCNIMMessageData:@{@"orderId":@(self.orderId),@"latitude":@(self.latitude),@"longitude":@(self.longitude),@"childName":self.childName}};
    return [dic jsonBody];
}
@end

@implementation XCNIMAgreePickAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(SNIMMsgTypeAgreePick), XCNIMMessageData:@{@"orderId":@(self.orderId),@"driverName":self.driverName,@"driverId":@(self.driverId)}};
    return [dic jsonBody];
}
@end

@implementation XCNIMOrderTipsAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(SNIMMsgTypeOrderTips), XCNIMMessageData:@{@"orderId":@(self.orderId),@"status":@(self.status),@"lat":@(self.lat),@"lng":@(self.lng),@"childName":self.childName}};
    return [dic jsonBody];
}
@end

@implementation XCNIMAudioOrVideoCallAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(XCNIMMsgTypeAudioOrVideoCall), XCNIMMessageData:@{@"callType":@(self.callType)}};
    return [dic jsonBody];
}
@end

@implementation XCNIMAddFriendRequestAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(XCNIMMsgTypeAddFriendRequest), XCNIMMessageData:@{@"attach":self.attach}};
    return [dic jsonBody];
}
@end

@implementation XCNIMAddFriendSucAttachment
-(NSString *)encodeAttachment{
    NSDictionary *dic = @{XCNIMMessageType:@(XCNIMMsgTypeAddFriendSuc), XCNIMMessageData:@{@"message":self.message}};
    return [dic jsonBody];
}
@end
