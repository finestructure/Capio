//
//  AppOverview.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppOverviewController.h"
#import "AppOverview.h"
#import "TimelineController.h"
#import "ServerOverviewController.h"
#import "AppConfigController.h"
#import "AppConnectionsController.h"
#import "Constants.h"
#import "DataStore.h"


@implementation AppOverviewController

@synthesize detailItem = _detailItem;
@synthesize performanceCostToggle = _performanceCostToggle;
@synthesize popover = _popover;
@synthesize appName = _appName;
@synthesize appDescription = _appDescription;
@synthesize appOwner = _appOwner;
@synthesize serverCount = _serverCount;
@synthesize ragRed = _ragRed;
@synthesize ragAmber = _ragAmber;
@synthesize ragGreen = _ragGreen;
@synthesize ragTotal = _ragTotal;
@synthesize timeline = _timeline;
@synthesize reportDateButton = _reportDateButton;


#pragma mark - Helpers


- (void)setTitle:(NSString *)title forButton:(UIButton *)button {
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitle:title forState:UIControlStateHighlighted];
  [button setTitle:title forState:UIControlStateSelected];
}


- (void)updateView {
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  }
  self.appName.text = self.detailItem.appName;
  self.appDescription.text = self.detailItem.appDescription;
  self.appOwner.text = self.detailItem.appOwner;
  self.serverCount.text = [NSString stringWithFormat:@"%d", [self.detailItem.serverList count]];
  NSString *reportDate = [dateFormatter stringFromDate:self.detailItem.reportDate];
  [self.reportDateButton setTitle:reportDate forState:UIControlStateNormal];
  [self.reportDateButton setTitle:reportDate forState:UIControlStateHighlighted];
  [self setTitle:[self.detailItem.ragRed stringValue] forButton:self.ragRed];
  [self setTitle:[self.detailItem.ragAmber stringValue] forButton:self.ragAmber];
  [self setTitle:[self.detailItem.ragGreen stringValue] forButton:self.ragGreen];
  [self setTitle:[self.detailItem.ragTotal stringValue] forButton:self.ragTotal];

  if ([self.detailItem.ragRed unsignedIntegerValue] == 0) {
    self.ragRed.enabled = NO;
  }
  if ([self.detailItem.ragAmber unsignedIntegerValue] == 0) {
    self.ragAmber.enabled = NO;
  }
  if ([self.detailItem.ragGreen unsignedIntegerValue] == 0) {
    self.ragGreen.enabled = NO;
  }
  if ([self.detailItem.ragTotal unsignedIntegerValue] == 0) {
    self.ragTotal.enabled = NO;
  }
}


#pragma mark - Actions


- (void)reportDateButtonTapped:(id)sender {
  DatePopupController *vc = [[DatePopupController alloc] initWithNibName:@"DatePopup" bundle:nil];
  vc.datePicker.date = self.detailItem.reportDate;
  vc.delegate = self;
  self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
  self.popover.delegate = self;
  self.popover.popoverContentSize = CGSizeMake(300, 260);
  [self.popover presentPopoverFromRect:self.reportDateButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
  // keep button selected while the popover is up
  self.reportDateButton.selected = YES;
}

- (IBAction)timelineTapped:(id)sender {
  TimelineController *vc = [[TimelineController alloc] initWithNibName:@"Timeline" bundle:nil];
  vc.title = NSLocalizedString(@"Application Timeline", @"App Timeline Title");
  [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)ragButtonTapped:(id)sender {
  NSUInteger count = 0;
  if (sender == self.ragRed) {
    count = [self.detailItem.ragRed unsignedIntegerValue];
  } else if (sender == self.ragAmber) {
    count = [self.detailItem.ragAmber unsignedIntegerValue];
  } else if (sender == self.ragGreen) {
    count = [self.detailItem.ragGreen unsignedIntegerValue];
  } else {
    count = [self.detailItem.ragTotal unsignedIntegerValue];
  }
  if (count == 1) {
    NSString *server = [self.detailItem.serverList objectAtIndex:0];
    NSDate *asof = self.detailItem.reportDate;    
    [[DataStore sharedDataStore] fetchDocument:server forDate:asof withCompletionBlock:^(NSDictionary *doc) {
      if (doc == nil) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          NSString *msg = [NSString stringWithFormat:@"No data available for '%@/%@'", server, [[YmdDateFormatter sharedInstance] stringFromDate:asof]];
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [alert show];
        }];
      } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
          ServerOverviewController *vc = [[ServerOverviewController alloc] initWithNibName:@"ServerOverview" bundle:nil];
          vc.detailItem = doc;
          [self.navigationController pushViewController:vc animated:YES];
        }];
      }
    }];
  } else if (count > 1) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented" message:@"Display of multiple servers not implemented yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}


- (IBAction)configTapped:(id)sender {
  AppConfigController *vc = [[AppConfigController alloc] initWithNibName:@"AppConfig" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)connectionsTapped:(id)sender {
  id vc = [[AppConnectionsController alloc] initWithNibName:@"AppConnections" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
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


- (void)viewDidLoad {
  [super viewDidLoad];

  // set button state image (combined state not possible via IB)
  UIImage *img = [UIImage imageNamed:@"dropdown_button_pressed.png"];
  [self.reportDateButton setBackgroundImage:img forState:UIControlStateSelected];
  [self.reportDateButton setBackgroundImage:img forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  [self updateView];
  
  self.title = NSLocalizedString(@"Application Overview", @"App Overview Title");
}

- (void)viewDidUnload
{
  [self setAppName:nil];
  [self setAppDescription:nil];
  [self setAppOwner:nil];
  [self setServerCount:nil];
  [self setPerformanceCostToggle:nil];
  [self setRagRed:nil];
  [self setRagAmber:nil];
  [self setRagGreen:nil];
  [self setRagTotal:nil];
  [self setReportDateButton:nil];
  [self setTimeline:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - DatePopupControllerDelegate


- (void)cancel:(id)sender {
  [self.popover dismissPopoverAnimated:YES];
  self.reportDateButton.selected = NO;  
}


- (void)done:(id)sender {
  DatePopupController *vc = (DatePopupController *)self.popover.contentViewController;
  NSLog(@"%@", vc.datePicker.date);
  if (! [self.detailItem.reportDate isEqualToDate:vc.datePicker.date]) {
    self.detailItem.reportDate = vc.datePicker.date;
    [self updateView];
  }
  [self.popover dismissPopoverAnimated:YES];
  self.reportDateButton.selected = NO;  
}


#pragma mark - UIPopoverController delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  self.reportDateButton.selected = NO;  
}


@end
