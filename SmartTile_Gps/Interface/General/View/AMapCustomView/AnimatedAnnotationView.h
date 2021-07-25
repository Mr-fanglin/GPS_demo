//
//  AnimatedAnnotationView.h
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/19.
//  Copyright © 2020 fanglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AnimatedAnnotationViewDelegate <NSObject>

@required
-(void)btnActionBlock:(NSString *)name;

@end

@interface AnimatedAnnotationView : MAAnnotationView

@property (nonatomic,retain) id <AnimatedAnnotationViewDelegate> delegate;

@property (nonatomic, strong) UIButton *imageView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong) UIView *calloutView;

@end

NS_ASSUME_NONNULL_END
