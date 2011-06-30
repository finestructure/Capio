//
//  AppOverview.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "MGSplitViewController.h"


@interface AppOverviewController : UIViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) id detailItem;

@end
