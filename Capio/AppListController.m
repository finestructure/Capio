//
//  AppList.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppListController.h"
#import "AppOverviewController.h"
#import "IntroViewController.h"
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
  [[DataStore sharedDataStore].fetchQueue addOperationWithBlock:^(void) {
    NSLog(@"Fetching ...");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.apps = [NSMutableArray array];
    self.displayedApps = [self.apps copy];
    [self.tableView reloadData];
    
    NSDictionary *doc = [[DataStore sharedDataStore] fetchDocument:@"apps"];
    NSLog(@"... done");
    if (doc == nil) {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *msg = [NSString stringWithFormat:@"Server '%@' did not return any data", [[DataStore sharedDataStore] baseUrl]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      }];
    } else {
      [doc enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
          NSDictionary *dict = (NSDictionary *)obj;
          AppOverview *item = [[AppOverview alloc] init];
          item.appName = [dict objectForKey:@"app_name"];
          item.appDescription = [dict objectForKey:@"app_description"];
          item.appOwner = [dict objectForKey:@"app_owner"];
          item.serverList = [dict objectForKey:@"server_list"];
          NSString *value = [dict objectForKey:@"report_date"];
          item.reportDate = [[YmdDateFormatter sharedInstance] dateFromString:value];
          item.ragRed = [dict objectForKey:@"red_rag_count"];
          item.ragAmber = [dict objectForKey:@"amber_rag_count"];
          item.ragGreen = [dict objectForKey:@"green_rag_count"];
          item.ragTotal = [NSNumber numberWithUnsignedInteger:[item.ragRed unsignedIntValue] + [item.ragAmber unsignedIntValue] + [item.ragGreen unsignedIntValue]];
          [self.apps addObject:item];
        }
      }];
      self.displayedApps = [self.apps copy];
    }
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];    
    NSLog(@"Reloaded");
  }];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAppList) name:kCouchServiceUrlChanged object:nil];

  [self fetchAppList];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellReuseIdentifier:@"AppListCell"];
  self.tableView.rowHeight = 52;
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];

  self.title = NSLocalizedString(@"Applications", @"AppList Controller Title");
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Actions


- (void)refresh:(id)sender {
  NSLog(@"Refreshing...");
  [self fetchAppList];
  
  id vc = [[IntroViewController alloc] initWithNibName:@"IntroView" bundle:nil];
  [self.detailViewController setViewControllers:[NSArray arrayWithObject:vc]];
}


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
                     
                     AppOverviewController *appOverviewController = [[AppOverviewController alloc] initWithNibName:@"AppOverview" bundle:nil];
                     appOverviewController.detailItem = app;
                     
                     NSArray *viewControllers = [NSArray arrayWithObject:appOverviewController];

                     [self.detailViewController setViewControllers:viewControllers animated:NO];
                     appOverviewController.view.alpha = 0;
                     
                     [UIView animateWithDuration:duration
                                      animations:^{
                                        appOverviewController.view.alpha = 1;
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
