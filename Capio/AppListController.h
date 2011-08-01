//
//  AppList.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppListController : UIViewController<UISearchBarDelegate> {
  UITableView *_tableView;
  UISearchBar *_searchBar;
}


@property (nonatomic, strong) NSArray *apps;
@property (strong, nonatomic) NSArray *displayedApps;

@property (strong, nonatomic) IBOutlet UINavigationController *detailViewController;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

- (void)searchButtonTapped:(id)sender;
- (void)refresh:(id)sender;

@end
