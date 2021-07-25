//
//  AnimatedAnnotation.h
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/19.
//  Copyright © 2020 fanglin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimatedAnnotation : NSObject<MAAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) float gensorOne;
@property (nonatomic, assign) float gensorTwo;
@property (nonatomic, assign) NSInteger childStatusType;

@property (nonatomic, strong) UIImage *animatedImage;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end

NS_ASSUME_NONNULL_END
