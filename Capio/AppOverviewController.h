//
//  AppOverview.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "MGSplitViewController.h"
#import "DatePopupController.h"


@class AppOverview;


@interface AppOverviewController : UIViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate, DatePopupControllerDelegate> {
  UILabel *_appName;
  UITextView *_appDescription;
  UILabel *_appOwner;
  UILabel *_serverCount;
  UIButton *_ragRed;
  UIButton *_ragAmber;
  UIButton *_ragGreen;
  UIButton *_ragTotal;
  UIButton *_timeline;
  UIView *_detailView;
  UIView *_blankView;
  UIButton *_reportDateButton;
  UISegmentedControl *_performanceCostToggle;
}


@property (strong, nonatomic) AppOverview *detailItem;

@property (nonatomic, strong) IBOutlet UISegmentedControl *performanceCostToggle;
@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, strong) IBOutlet UILabel *appName;
@property (nonatomic, strong) IBOutlet UITextView *appDescription;
@property (nonatomic, strong) IBOutlet UILabel *appOwner;
@property (nonatomic, strong) IBOutlet UILabel *serverCount;
@property (nonatomic, strong) IBOutlet UIButton *reportDateButton;

@property (nonatomic, strong) IBOutlet UIButton *ragRed;
@property (nonatomic, strong) IBOutlet UIButton *ragAmber;
@property (nonatomic, strong) IBOutlet UIButton *ragGreen;
@property (nonatomic, strong) IBOutlet UIButton *ragTotal;

@property (nonatomic, strong) IBOutlet UIButton *timeline;

@property (nonatomic, strong) IBOutlet UIView *detailView;
@property (nonatomic, strong) IBOutlet UIView *blankView;

- (IBAction)reportDateButtonTapped:(id)sender;
- (IBAction)timelineTapped:(id)sender;
- (IBAction)ragButtonTapped:(id)sender;

- (void)updateView;

@end
