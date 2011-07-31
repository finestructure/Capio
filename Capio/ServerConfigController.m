//
//  ServerConfigController.m
//  Capio
//
//  Created by Sven A. Schmidt on 26.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ServerConfigController.h"

@implementation ServerConfigController

@synthesize detailItem = _detailItem;
@synthesize parentDetailItem = _parentDetailItem;
@synthesize serverName = _serverName;
@synthesize reportDate = _reportDate;
@synthesize tableview = _tableview;


#pragma mark - Workers


- (void)updateView {
  NSLog(@"server: %@", [self.parentDetailItem objectForKey:@"hostname"]);
  self.serverName.text = [self.parentDetailItem objectForKey:@"hostname"];
  self.reportDate.text = [self.parentDetailItem objectForKey:@"asof"];
}


- (void)setParentDetailItem:(NSDictionary *)newDetailItem {  
  if (_parentDetailItem != newDetailItem) {
    _parentDetailItem = newDetailItem;
    // parent detail item affects the server and asof labels
    [self updateView];
  }
}


#pragma mark - Initializers


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Server Configuration", @"Server Config Title");
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.detailItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConfigCell"];
  
  // Configure the cell
  NSArray *pair = [self.detailItem objectAtIndex:indexPath.row];
  cell.textLabel.text = [pair objectAtIndex:0];
  cell.detailTextLabel.text = [pair objectAtIndex:1];
  
  return cell;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableview.layer.borderWidth = 1.0;
  self.tableview.layer.borderColor = [[UIColor lightGrayColor] CGColor];

  [self updateView];
}

- (void)viewDidUnload
{
  [self setTableview:nil];
  [self setServerName:nil];
  [self setReportDate:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
