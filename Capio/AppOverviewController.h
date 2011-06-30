//
//  AppOverview.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "MGSplitViewController.h"


@interface AppOverviewController : UIViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate> {
  UILabel *_appName;
  UITextView *_appDescription;
  UILabel *_appOwner;
  UILabel *_serverCount;
  UILabel *_reportDate;
  UISegmentedControl *_performanceCostToggle;
}


@property (strong, nonatomic) id detailItem;

@property (nonatomic, strong) IBOutlet UISegmentedControl *performanceCostToggle;
@property (nonatomic, strong) IBOutlet UILabel *appName;
@property (nonatomic, strong) IBOutlet UITextView *appDescription;
@property (nonatomic, strong) IBOutlet UILabel *appOwner;
@property (nonatomic, strong) IBOutlet UILabel *serverCount;
@property (nonatomic, strong) IBOutlet UILabel *reportDate;


@end
