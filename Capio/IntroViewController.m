//
//  IntroViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 28.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "IntroViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation IntroViewController

@synthesize origFrameAppArrowView = _origFrameAppArrowView;
@synthesize origFrameTabArrowView = _origFrameTabArrowView;
@synthesize appArrowView = _appArrowView;
@synthesize tabArrowView = _tabArrowView;
@synthesize versionButton = _versionButton;


#pragma mark - Helpers


- (void)animateViews {
  self.origFrameAppArrowView = self.appArrowView.frame;
  self.origFrameTabArrowView = self.tabArrowView.frame;
  
  [UIView animateWithDuration:0.5
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
  
//  {
//    UIView *view = self.appArrowView;
//    
//    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
//    CGFloat x_max = self.origFrameAppArrowView.origin.x;
//    bounceAnimation.values = [NSArray arrayWithObjects:
//                              [NSNumber numberWithFloat:0],
//                              [NSNumber numberWithFloat:-x_max],
//                              [NSNumber numberWithFloat:-x_max + 30],
//                              [NSNumber numberWithFloat:-x_max],
//                              //[NSNumber numberWithFloat:-x_max + 21],
//                              //[NSNumber numberWithFloat:-x_max],
//                              nil];
//    bounceAnimation.duration = 1.0;
//    bounceAnimation.removedOnCompletion = NO;
//    bounceAnimation.fillMode = kCAFillModeForwards;
//    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
//  }
}

#pragma mark - Actions


- (IBAction)versionTapped:(id)sender {
  self.appArrowView.frame = self.origFrameAppArrowView;
  self.tabArrowView.frame = self.origFrameTabArrowView;
  [self animateViews];
}


#pragma mark - Initializers


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Introduction", @"Intro View Title");
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
  
  NSString *version = [[[NSBundle mainBundle] infoDictionary]
                       objectForKey:@"CFBundleVersion"];
  [self.versionButton setTitle:version forState:UIControlStateNormal];
  [self.versionButton setTitle:version forState:UIControlStateHighlighted];
  [self.versionButton setTitle:version forState:UIControlStateSelected];
  
  [self animateViews];
}

- (void)viewDidUnload
{
  [self setAppArrowView:nil];
  [self setTabArrowView:nil];
  [self setVersionButton:nil];
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
