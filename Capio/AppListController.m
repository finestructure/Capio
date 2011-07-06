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


@implementation AppListController

@synthesize appOverviewController = _appOverviewController;
@synthesize apps = _apps;
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.apps = [NSMutableArray array];
  
  NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [thisBundle URLForResource:@"app_overview" withExtension:@"plist"];
  
  NSArray *data = [NSArray arrayWithContentsOfURL:url];
  for (NSDictionary *dict in data) {
    AppOverview *item = [[AppOverview alloc] init];
    item.appName = [dict objectForKey:@"appName"];
    item.appDescription = [dict objectForKey:@"appDescription"];
    item.appOwner = [dict objectForKey:@"appOwner"];
    item.serverCount = [dict objectForKey:@"serverCount"];
    item.reportDate = [dict objectForKey:@"reportDate"];
    item.ragRed = [dict objectForKey:@"ragRed"];
    item.ragAmber = [dict objectForKey:@"ragAmber"];
    item.ragGreen = [dict objectForKey:@"ragGreen"];
    item.ragTotal = [dict objectForKey:@"ragTotal"];
    [self.apps addObject:item];
  }
  
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
  CGRect targetSearchFrame;
  CGFloat targetAlpha;

  if (self.searchBar.alpha == 0) {
    [self.view addSubview:self.searchBar];
    
//    CGRect startFrame = self.searchBar.frame;
//    startFrame.origin = CGPointMake(0, -height);
//    self.searchBar.frame = startFrame;
//    targetSearchFrame.origin = CGPointMake(0, 0);
    
    targetTableViewFrame.origin.y += height;
    targetAlpha = 1;
  } else {
    [self.searchBar removeFromSuperview];
    targetTableViewFrame.origin.y -= height;
    targetAlpha = 0;
  }

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:0.3];
  
  self.tableView.frame = targetTableViewFrame;
  self.searchBar.alpha = targetAlpha;
  //self.searchBar.frame = targetSearchFrame;
  
  [UIView commitAnimations];
}


- (void)searchButtonTapped:(id)sender {
  [self toggleSearchbar];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.apps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AppListCell *cell = (AppListCell *)[tableView dequeueReusableCellWithIdentifier:@"AppListCell"];
  
  // Configure the cell
  AppOverview *item = [self.apps objectAtIndex:indexPath.row];
  cell.appName.text = item.appName;
  cell.ragRed.text = [item.ragRed stringValue];
  cell.ragAmber.text = [item.ragAmber stringValue];
  
  return cell;
  
  /*
   
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell
  AppOverview *item = [self.apps objectAtIndex:indexPath.row];
  cell.textLabel.text = item.appName;
  
  return cell;
   */
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
  AppOverview *item = [self.apps objectAtIndex:indexPath.row];
  self.appOverviewController.detailItem = item;
}

- (void)viewDidUnload {
  [self setTableView:nil];
  [self setSearchBar:nil];
  [super viewDidUnload];
}
@end
