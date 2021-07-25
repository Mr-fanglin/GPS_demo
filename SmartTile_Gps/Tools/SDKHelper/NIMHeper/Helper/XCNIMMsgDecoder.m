//
//  SNIMMsgDecoder.m
//  Sheng
//
//  Created by Fanglin on 2017/8/18.
//  Copyright © 2017年 Fanglin. All rights reserved.
//

#import "XCNIMMsgDecoder.h"
#import "XCNIMMsgAttachment.h"
#import "NSDictionary+NTESJson.h"

@implementation XCNIMMsgDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    id<NIMCustomAttachment> attachment = nil;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]){
            NSInteger type     = [dict jsonInteger:XCNIMMessageType];
            NSDictionary *dataDic = [dict jsonDict:XCNIMMessageData];
            switch (type) {
                case SNIMMsgTypeChildAskPick:
                    attachment = [[XCNIMChildAskPickAttachment alloc]init];
                    ((XCNIMChildAskPickAttachment *)attachment).orderId = [dataDic jsonInteger:@"orderId"];
                    ((XCNIMChildAskPickAttachment *)attachment).childId = [dataDic jsonInteger:@"childId"];
                    ((XCNIMChildAskPickAttachment *)attachment).childName = [dataDic jsonString:@"childName"];
                    ((XCNIMChildAskPickAttachment *)attachment).latitude = [dataDic jsonDouble:@"latitude"];
                    ((XCNIMChildAskPickAttachment *)attachment).longitude = [dataDic jsonDouble:@"longitude"];
                    break;
                case SNIMMsgTypeSendRequestPick:
                    attachment = [[XCNIMSendRequestPickAttachment alloc]init];
                    ((XCNIMSendRequestPickAttachment *)attachment).orderId = [dataDic jsonInteger:@"orderId"];
                    ((XCNIMSendRequestPickAttachment *)attachment).userId = [dataDic jsonInteger:@"userId"];
                    ((XCNIMSendRequestPickAttachment *)attachment).userName = [dataDic jsonString:@"userName"];
                    ((XCNIMSendRequestPickAttachment *)attachment).fromAddress = [dataDic jsonString:@"fromAddress"];
                    ((XCNIMSendRequestPickAttachment *)attachment).toAddress = [dataDic jsonString:@"toAddress"];
                    ((XCNIMSendRequestPickAttachment *)attachment).latitude = [dataDic jsonDouble:@"latitude"];
                    ((XCNIMSendRequestPickAttachment *)attachment).longitude = [dataDic jsonDouble:@"longitude"];
                    ((XCNIMSendRequestPickAttachment *)attachment).toLatitude = [dataDic jsonDouble:@"toLatitude"];
                    ((XCNIMSendRequestPickAttachment *)attachment).toLongitude = [dataDic jsonDouble:@"toLongitude"];
                    break;
                case SNIMMsgTypeHelpPick:
                    attachment = [[XCNIMHelpPickAttachment alloc]init];
                    ((XCNIMHelpPickAttachment *)attachment).orderId = [dataDic jsonInteger:@"orderId"];
                    ((XCNIMHelpPickAttachment *)attachment).childName = [dataDic jsonString:@"childName"];
                    ((XCNIMHelpPickAttachment *)attachment).latitude = [dataDic jsonDouble:@"latitude"];
                    ((XCNIMHelpPickAttachment *)attachment).longitude = [dataDic jsonDouble:@"longitude"];
                    break;
                case SNIMMsgTypeAgreePick:
                    attachment = [[XCNIMAgreePickAttachment alloc]init];
                    ((XCNIMAgreePickAttachment *)attachment).orderId = [dataDic jsonInteger:@"orderId"];
                    ((XCNIMAgreePickAttachment *)attachment).driverId = [dataDic jsonInteger:@"driverId"];
                    ((XCNIMAgreePickAttachment *)attachment).driverName = [dataDic jsonString:@"driverName"];
                    break;
                case SNIMMsgTypeOrderTips:
                    attachment = [[XCNIMOrderTipsAttachment alloc]init];
                    ((XCNIMOrderTipsAttachment *)attachment).orderId = [dataDic jsonInteger:@"orderId"];
                    ((XCNIMOrderTipsAttachment *)attachment).status = [dataDic jsonInteger:@"status"];
                    ((XCNIMOrderTipsAttachment *)attachment).childName = [dataDic jsonString:@"childName"];
                    ((XCNIMOrderTipsAttachment *)attachment).lat = [dataDic jsonDouble:@"lat"];
                    ((XCNIMOrderTipsAttachment *)attachment).lng = [dataDic jsonDouble:@"lng"];
                    break;
                case XCNIMMsgTypeAudioOrVideoCall:
                    attachment = [[XCNIMAudioOrVideoCallAttachment alloc]init];
                    ((XCNIMAudioOrVideoCallAttachment *)attachment).callType = [dataDic jsonInteger:@"callType"];
                    break;
                case XCNIMMsgTypeAddFriendRequest:
                    attachment = [[XCNIMAddFriendRequestAttachment alloc]init];
                    ((XCNIMAddFriendRequestAttachment *)attachment).attach = [dataDic jsonString:@"attach"];
                    break;
                case XCNIMMsgTypeAddFriendSuc:
                    attachment = [[XCNIMAddFriendSucAttachment alloc]init];
                    ((XCNIMAddFriendSucAttachment *)attachment).message = [dataDic jsonString:@"message"];
                    break;
                default:
                    break;
            }
        }
    }
    return attachment;
}
@end
