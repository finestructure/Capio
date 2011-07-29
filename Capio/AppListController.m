//
//  AppList.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppListController.h"
#import "AppOverviewController.h"
#import "AppOverview.h"
#import "AppListCell.h"
#import "DataStore.h"
#import "Constants.h"


@implementation AppListController

@synthesize detailViewController = _detailViewController;
@synthesize apps = _apps;
@synthesize displayedApps = _displayedApps;
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;


#pragma mark - Workers


- (void)fetchAppList {
  self.apps = [[DataStore sharedDataStore] appList];
  self.displayedApps = [self.apps copy];
  [self.tableView reloadData];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAppList) name:kCouchServiceUrlChanged object:nil];

  [self fetchAppList];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellReuseIdentifier:@"AppListCell"];
  self.tableView.rowHeight = 52;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Actions


- (void)toggleSearchbar {
  CGFloat height = self.searchBar.bounds.size.height;
  CGRect targetTableViewFrame = self.tableView.frame;
  CGFloat targetAlpha;

  if (self.searchBar.alpha < 1) { // show
    [self.view addSubview:self.searchBar];    
    targetTableViewFrame.origin.y += height;
    targetAlpha = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(searchButtonTapped:)];
  } else { // hide
    targetTableViewFrame.origin.y -= height;
    targetAlpha = 0.2;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
  }

  [UIView animateWithDuration:0.3
                   animations:^{
                     self.tableView.frame = targetTableViewFrame;
                     self.searchBar.alpha = targetAlpha;  
                   }
                   completion:^(BOOL finished){
                     if (self.searchBar.alpha < 1) {
                       [self.searchBar removeFromSuperview];
                     }
                   }];
}


- (void)searchButtonTapped:(id)sender {
  [self toggleSearchbar];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.displayedApps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AppListCell *cell = (AppListCell *)[tableView dequeueReusableCellWithIdentifier:@"AppListCell"];
  
  // Configure the cell
  AppOverview *item = [self.displayedApps objectAtIndex:indexPath.row];
  cell.appName.text = item.appName;
  [cell setRedRagValue:[item.ragRed unsignedIntegerValue]];
  [cell setAmberRagValue:[item.ragAmber unsignedIntegerValue]];
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
  NSTimeInterval duration = 0.05;
  UIView *visibleView = self.detailViewController.visibleViewController.view;

  [UIView animateWithDuration:duration
                   animations:^{
                     visibleView.alpha = 0;
                   }
                   completion:^(BOOL finished){
                     AppOverview *app = [self.displayedApps objectAtIndex:indexPath.row];
                     
                     AppOverviewController *newViewController = [[AppOverviewController alloc] initWithNibName:@"AppOverview" bundle:nil];
                     newViewController.detailItem = app;

                     [self.detailViewController setViewControllers:[NSArray arrayWithObject:newViewController] animated:NO];
                     newViewController.view.alpha = 0;
                     
                     [UIView animateWithDuration:duration
                                      animations:^{
                                        newViewController.view.alpha = 1;
                                      }];
                   }];
}

- (void)viewDidUnload {
  [self setTableView:nil];
  [self setSearchBar:nil];
  [super viewDidUnload];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  NSString *asterisk = @"*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like[cd] %@",
                            @"appName", [[asterisk stringByAppendingString:searchText] stringByAppendingString:asterisk]];
  self.displayedApps = [self.apps filteredArrayUsingPredicate:predicate];
  [self.tableView reloadData];
}


@end
