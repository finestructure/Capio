//
//  ConfigViewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGSplitViewController.h"
#import "BonjourBrowser.h"


@interface SettingsController : UIViewController <BonjourBrowserDelegate, UIWebViewDelegate> {
  UIView *_masterView;
  UIView *_detailView;
  UINavigationController *_masterViewController;
  UIViewController *_detailViewController;
  UITableView *_tableView;
}

@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) IBOutlet UIView *masterView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UINavigationController *masterViewController;
@property (strong, nonatomic) IBOutlet UIViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
