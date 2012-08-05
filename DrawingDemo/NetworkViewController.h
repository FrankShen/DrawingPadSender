//
//  NetworkViewController.h
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-4.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingDemoAppDelegate.h"
@interface NetworkViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *hostAddress;
@property (weak, nonatomic) IBOutlet UITextField *portAddress;

@end
