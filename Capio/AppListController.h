//
//  AppList.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppOverviewController;

@interface AppListController : UIViewController {
  UITableView *_tableView;
}


@property (nonatomic, strong) NSMutableArray *apps;

@property (strong, nonatomic) IBOutlet AppOverviewController *appOverviewController;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
