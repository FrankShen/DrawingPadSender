//
//  HelpViewController.m
//  DrawingDemo
//
//  Created by BuG.BS on 12-8-4.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationLandscapeLeft;
}
- (IBAction)startButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"startDraw" sender:self];
}

@end
