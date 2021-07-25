//
//  AnimatedAnnotation.m
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/19.
//  Copyright © 2020 fanglin. All rights reserved.
//

#import "AnimatedAnnotation.h"

@implementation AnimatedAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize gensorOne = _gensorOne;
@synthesize gensorTwo = _gensorTwo;
@synthesize coordinate = _coordinate;
@synthesize childStatusType = _childStatusType;
@synthesize animatedImage = _animatedImage;
#pragma mark - life cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
        
    }
    return self;
}

@end
