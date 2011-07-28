//
//  IntroViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 28.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "IntroViewController.h"

@implementation IntroViewController
@synthesize appArrowView = _appArrowView;
@synthesize tabArrowView = _tabArrowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.appArrowView.alpha = 0;
  self.tabArrowView.alpha = 0;
  
  [UIView animateWithDuration:1.0
                   animations:^{
                     {
                       self.appArrowView.alpha = 1;
                       CGRect target = self.appArrowView.frame;
                       target.origin.x = 0;
                       self.appArrowView.frame = target;
                     }
                     {
                       self.tabArrowView.alpha = 1;
                       CGRect target = self.tabArrowView.frame;
                       target.origin.y = 567;
                       self.tabArrowView.frame = target;
                     }
                   }
                   completion:^(BOOL finished){

                   }];
}

- (void)viewDidUnload
{
  [self setAppArrowView:nil];
  [self setTabArrowView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
