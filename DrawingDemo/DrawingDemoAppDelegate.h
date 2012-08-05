//
//  DrawingDemoAppDelegate.h
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-3.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#define CONFIRM_CONNECTION_TAG 1000
#define START_TRANSPORT 1001
#define TRANSPORT_CONPLETE 1002

@interface DrawingDemoAppDelegate : UIResponder <UIApplicationDelegate,GCDAsyncSocketDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GCDAsyncSocket *socket;

@property (strong, nonatomic) NSString *socketIdx;

@end
