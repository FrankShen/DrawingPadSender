//
//  SmoothLineView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 1.0f
#define LOW_PASS_FILTER 0.5f

@interface SmoothLineView () 

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView

#pragma mark -

- (void)addTime
{
    timeInterval++;
    //NSLog(@"%d",timeInterval);
}

-(void)setup
{
    self.lineWidth = DEFAULT_WIDTH;
    self.lineColor = DEFAULT_COLOR;
    self.backgroundColor = [UIColor clearColor];
    timer = [[NSTimer alloc] init];
    
    isErase = NO;
    doNotDraw = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];    // Define the background color
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    previousTime = 0;
    previousSpeed = 0;
    previousWidth = 2;
    

    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    [timer fire];
    
    NSLog(@"Began %d", touches.count);
    if (touches.count  > 1) {
        [timer invalidate];
        doNotDraw = YES;
        return;
    }
    if (touches.count == 1){
        doNotDraw = NO;
    }
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Move %d", touches.count);
    
    if (doNotDraw){
        [timer invalidate];
        return;
    }
    if (touches.count  > 1) {
        doNotDraw = YES;
        return;
    }
    UITouch *touch  = [touches anyObject];
    
    long currentTime = timeInterval;
    
    
    previousPoint2  = previousPoint1;
    previousPoint1 = currentPoint;
    currentPoint    = [touch locationInView:self];
    
    float speed = sqrt((currentPoint.x - previousPoint1.x)*(currentPoint.x - previousPoint1.x)+(currentPoint.y - previousPoint1.y)*(currentPoint.y - previousPoint1.y))/(currentTime - previousTime);
    
    speed = previousSpeed * LOW_PASS_FILTER + speed * (1 - LOW_PASS_FILTER);
    
    previousSpeed = speed;
    
    
    self.lineWidth = speed * 20;
    if (lineWidth - previousWidth > 1){
        lineWidth = previousWidth + 1;
    }
    if (lineWidth - previousWidth < -1){
        lineWidth = previousWidth - 1;
    }
    
    if (lineWidth < 2)
        lineWidth = 2;
    if (lineWidth > 20)
        lineWidth = 20;
    
    previousWidth = lineWidth;
    
    previousTime = currentTime;
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2); 
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	curImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [timer invalidate];
    timeInterval = 0;
}

- (void)drawRect:(CGRect)rect
{
    [curImage drawAtPoint:CGPointMake(0, 0)];
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    if (trashSignal){
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextFillRect(context, rect);
        trashSignal = NO;
        [super drawRect:rect];
        return;
    }
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    
    if (self.isErase){
        //CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetLineWidth(context, 30.0);
    } else {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextSetLineWidth(context, self.lineWidth);
   
    }
    
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
    
    
}

- (void)getTheImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

- (void)swipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateChanged){
        NSLog(@"swipe");
        
        [self getTheImage];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD showWhileExecuting:@selector(sendTheImage) onTarget:self withObject:nil animated:YES];
    }
}

- (void)sendTheImage
{
    DrawingDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSData *data = UIImagePNGRepresentation(self.image);
    NSLog(@"%d",data.length);
    [appDelegate.socket writeData:[[NSString stringWithFormat:@"%@,%d",appDelegate.socketIdx,data.length] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:START_TRANSPORT];
    [appDelegate.socket writeData:data withTimeout:-1 tag:[appDelegate.socketIdx intValue]];
    [appDelegate.socket readDataWithTimeout:-1 tag:TRANSPORT_CONPLETE];
    
}

- (void)dealloc
{
    self.lineColor = nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
	hud = nil;
}

@synthesize lineColor,lineWidth,isErase,trashSignal;
@end


