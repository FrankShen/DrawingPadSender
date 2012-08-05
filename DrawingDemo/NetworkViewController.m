//
//  NetworkViewController.m
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-4.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController
@synthesize hostAddress;
@synthesize portAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setHostAddress:nil];
    [self setPortAddress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (IBAction)connectButtonPressed:(id)sender
{
    DrawingDemoAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.socket = [[GCDAsyncSocket alloc] initWithDelegate:[[UIApplication sharedApplication] delegate] delegateQueue:dispatch_get_main_queue()];
    [appDelegate.socket connectToHost:self.hostAddress.text onPort:[self.portAddress.text intValue] error:nil];
    [appDelegate.socket readDataWithTimeout:-1 tag:CONFIRM_CONNECTION_TAG];
    [self performSegueWithIdentifier:@"connectionEstablished" sender:self];
}
@end
