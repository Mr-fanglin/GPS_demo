//
//  AnimatedAnnotationView.m
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/19.
//  Copyright © 2020 fanglin. All rights reserved.
//

#import "AnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#import "CustomCalloutView.h"

#define kWidth          60.f
#define kHeight         60.f
#define kTimeInterval   0.15f

#define kCalloutWidth   150.0
#define kCalloutHeight  60

@interface AnimatedAnnotationView ()
{
    UILabel *nameL;
    UILabel *timeL;
    UILabel *gensorOneL;
    UILabel *gensorTwoL;
    UILabel *sosNameL;
    UIButton *btn;
}


@end

@implementation AnimatedAnnotationView
@synthesize imageView = _imageView;

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageView = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.frame = self.bounds;
        [self.imageView setAdjustsImageWhenHighlighted:NO];
        [self.imageView setUserInteractionEnabled:NO];
        
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    [self.imageView setImage:animatedAnnotation.animatedImage forState:UIControlStateNormal];
    
    [animatedAnnotation addObserver:self forKeyPath:@"childStatusType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
        if (self.calloutView == nil)
        {
            
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kCalloutWidth, 18)];
            nameL.font = [UIFont systemFontOfSize:17];
            nameL.backgroundColor = [UIColor clearColor];
            nameL.textColor = [UIColor whiteColor];
            nameL.text = animatedAnnotation.title;
            nameL.textAlignment = NSTextAlignmentCenter;
            [self.calloutView addSubview:nameL];
            
            timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kCalloutWidth, 15)];
            timeL.font = [UIFont systemFontOfSize:13];
            timeL.backgroundColor = [UIColor clearColor];
            timeL.textColor = [UIColor whiteColor];
            timeL.text = animatedAnnotation.subtitle;
            timeL.textAlignment = NSTextAlignmentCenter;
            [self.calloutView addSubview:timeL];
            
            gensorOneL = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, kCalloutWidth/2-10, 15)];
            gensorOneL.font = [UIFont systemFontOfSize:13];
            gensorOneL.backgroundColor = [UIColor clearColor];
            if (animatedAnnotation.gensorOne<=3.0) {
                gensorOneL.textColor = [UIColor greenColor];
            }else if (animatedAnnotation.gensorOne>3 && animatedAnnotation.gensorOne<=5) {
                gensorOneL.textColor = [UIColor yellowColor];
            }else if (animatedAnnotation.gensorOne>5) {
                gensorOneL.textColor = [UIColor redColor];
            }
            gensorOneL.text = [NSString stringWithFormat:@"G1:%.2f",animatedAnnotation.gensorOne];
            gensorOneL.textAlignment = NSTextAlignmentCenter;
//            [self.calloutView addSubview:gensorOneL];
            
            gensorTwoL = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutWidth/2+5, 44, kCalloutWidth/2-10, 15)];
            gensorTwoL.font = [UIFont systemFontOfSize:13];
            gensorTwoL.backgroundColor = [UIColor clearColor];
            if (animatedAnnotation.gensorTwo<=3.0) {
                gensorTwoL.textColor = [UIColor greenColor];
            }else if (animatedAnnotation.gensorTwo>3 && animatedAnnotation.gensorTwo<=5) {
                gensorTwoL.textColor = [UIColor yellowColor];
            }else if (animatedAnnotation.gensorTwo>5) {
                gensorTwoL.textColor = [UIColor redColor];
            }
            gensorTwoL.text = [NSString stringWithFormat:@"G2:%.2f",animatedAnnotation.gensorTwo];
            gensorTwoL.textAlignment = NSTextAlignmentCenter;
//            [self.calloutView addSubview:gensorTwoL];
            
            sosNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kCalloutWidth, 60)];
            sosNameL.font = [UIFont systemFontOfSize:30];
            sosNameL.backgroundColor = [UIColor clearColor];
            sosNameL.textColor = [UIColor redColor];
            sosNameL.text = @"SOS";
            sosNameL.textAlignment = NSTextAlignmentCenter;
            [sosNameL setHidden:YES];
            [self.calloutView addSubview:sosNameL];
            
            btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(20, 80, kCalloutWidth-40, 34);
            [btn setTitle:@"Cancel" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor lightGrayColor]];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius = 17;
            btn.layer.masksToBounds = YES;
            [btn setHidden:YES];
            [self.calloutView addSubview:btn];
            
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}


- (NSString *)name
{
    return self.name;
}

- (void)setName:(NSString *)name
{
    self.name = name;
}

-(NSString *)time
{
    return self.time;
}
- (void)setTime:(NSString *)time
{
    self.time = time;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}


#pragma mark - Handle Action

- (void)btnAction
{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    if ([self.delegate respondsToSelector:@selector(btnActionBlock:)]) {
        [self.delegate btnActionBlock:animatedAnnotation.title];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"childStatusType"]) {
        NSNumber *type = [change valueForKey:@"new"];
        if ([type intValue] == 1) {
            self.calloutView.frame = CGRectMake(0, 0, kCalloutWidth, 150);
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            [sosNameL setHidden:NO];
            [btn setHidden:NO];
            [timeL setHidden:YES];
            [nameL setHidden:YES];
//            [gensorOneL setHidden:YES];
//            [gensorTwoL setHidden:YES];
        }else if ([type intValue] == 0) {
            self.calloutView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            [sosNameL setHidden:YES];
            [btn setHidden:YES];
            [timeL setHidden:NO];
            [nameL setHidden:NO];
//            [gensorOneL setHidden:NO];
//            [gensorTwoL setHidden:NO];
        }
    }
}

@end
