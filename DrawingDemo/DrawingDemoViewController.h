//
//  DrawingDemoViewController.h
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-3.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>
@interface DrawingDemoViewController : UIViewController
@property (weak, nonatomic) IBOutlet SmoothLineView *drawingPad;
@property (weak, nonatomic) IBOutlet UIButton *penButton;
@property (weak, nonatomic) IBOutlet UIButton *eraserButton;
@end
