//
//  EQAnnotationView.m
//  Earthquakes
//
//  Created by Lea Marolt on 2/13/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "EQAnnotationView.h"

@implementation EQAnnotationView

- (instancetype)initWithMagnitudeOfEarthquake:(EQEarthquake *) eq;
{
    self = [super init];
    if (self) {
        
        //setup
    }
    
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        for (UIView *subview in [self.superview subviews]) {
            if (subview.tag == 113) {
                [subview removeFromSuperview];
            }
        }
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

@end
