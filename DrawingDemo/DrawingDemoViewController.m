//
//  DrawingDemoViewController.m
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-3.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "DrawingDemoViewController.h"

@interface DrawingDemoViewController ()

@end

@implementation DrawingDemoViewController
@synthesize drawingPad;
//@synthesize gestureView;
@synthesize penButton;
@synthesize eraserButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.penButton setSelected:YES];
    [self.eraserButton setSelected:NO];
    [self.drawingPad setMultipleTouchEnabled:YES];
    //self.gestureView.backgroundColor = [UIColor clearColor];
    UISwipeGestureRecognizer *ges = [[UISwipeGestureRecognizer alloc] initWithTarget:self.drawingPad action:@selector(swipe:)];
    ges.numberOfTouchesRequired = 2;
    ges.direction = UISwipeGestureRecognizerDirectionUp;
    [self.drawingPad addGestureRecognizer:ges];
    
}

- (void)viewDidUnload
{
    [self setDrawingPad:nil];
    [self setPenButton:nil];
    [self setEraserButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationLandscapeLeft;
}

+ (UIImage *)getImageFromView:(UIView *)orgView
{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)penButtonPressed:(id)sender
{
    [self.penButton setSelected:YES];
    [self.eraserButton setSelected:NO];
    self.drawingPad.isErase = NO;
}

- (IBAction)eraserButtonPressed:(id)sender
{
    [self.penButton setSelected:NO];
    [self.eraserButton setSelected:YES];
    self.drawingPad.isErase = YES;
}

- (IBAction)trashButtonPressed:(id)sender
{
    self.drawingPad.trashSignal = YES;
    [self.drawingPad setNeedsDisplay];
}


@end
