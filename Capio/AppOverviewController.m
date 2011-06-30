//
//  AppOverview.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppOverviewController.h"

@implementation AppOverviewController

@synthesize detailItem = _detailItem;
@synthesize performanceCostToggle = _performanceCostToggle;
@synthesize appName = _appName;
@synthesize appDescription = _appDescription;
@synthesize appOwner = _appOwner;
@synthesize serverCount = _serverCount;
@synthesize reportDate = _reportDate;


#pragma mark -
#pragma mark Managing the detail item


// When setting the detail item, update the view and dismiss the popover controller if it's showing.
- (void)setDetailItem:(id)newDetailItem {
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    
    // Update the view.
    self.appDescription.text = [_detailItem description];
  }
}


#pragma mark -
#pragma mark Split view support


- (void)splitViewController:(MGSplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc 
          popoverController:(UIPopoverController*)pc 
  willPresentViewController:(UIViewController *)aViewController
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willChangeSplitOrientationToVertical:(BOOL)isVertical
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willMoveSplitToPosition:(float)position
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (float)splitViewController:(MGSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	return proposedPosition;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [self setAppName:nil];
  [self setAppDescription:nil];
  [self setAppOwner:nil];
  [self setServerCount:nil];
  [self setReportDate:nil];
  [self setPerformanceCostToggle:nil];
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
