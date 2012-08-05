//
//  SmoothLineView.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingDemoAppDelegate.h"
#import "MBProgressHUD.h"


@interface SmoothLineView : UIView <MBProgressHUDDelegate>{
    @private
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    UIImage *curImage;
    NSTimer *timer;
    long timeInterval;
    long previousTime;
    long previousSpeed;
    long previousWidth;
    BOOL doNotDraw;
    
}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property (readwrite) BOOL isErase;
@property (readwrite) BOOL trashSignal;
@property (nonatomic, strong) UIImage *image;

- (void)swipe:(UISwipeGestureRecognizer *)gesture;

@end
