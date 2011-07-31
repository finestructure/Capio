//
//  ServerOverviewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 19.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ServerOverviewController.h"
#import "MetricOverviewController.h"
#import "TimelineController.h"
#import "ServerConfigController.h"

@implementation ServerOverviewController

@synthesize imageView = _imageView;
@synthesize detailItem = _detailItem;
@synthesize serverName = _serverName;
@synthesize reportDate = _reportDate;


#pragma mark - Workers


- (void)updateView {
  self.serverName.text = [self.detailItem objectForKey:@"hostname"];
  self.reportDate.text = [self.detailItem objectForKey:@"asof"];
}


#pragma mark - Actions


- (IBAction)metricsTapped:(id)sender {
  id vc = [[MetricOverviewController alloc] initWithNibName:@"MetricOverview" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)timelineTapped:(id)sender {
  TimelineController *vc = [[TimelineController alloc] initWithNibName:@"Timeline" bundle:nil];
  vc.title = NSLocalizedString(@"Server Timeline", @"Server Timeline Title");
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)configTapped:(id)sender {
  id config = [self.detailItem objectForKey:@"config"];
  
  if (config != nil) {
    ServerConfigController *vc = [[ServerConfigController alloc] initWithNibName:@"ServerConfig" bundle:nil];
    vc.detailItem = config;
    vc.parentDetailItem = self.detailItem;
    [self.navigationController pushViewController:vc animated:YES];
  }
}


- (IBAction)segmentTapped:(id)sender {
  UISegmentedControl *segment = (UISegmentedControl *)sender;

  switch (segment.selectedSegmentIndex) {
    case 0: {
      self.imageView.image = [UIImage imageNamed:@"response_workloads.png"];
      break;
    }
    
    case 1: {
      self.imageView.image = [UIImage imageNamed:@"response_trend.png"];
      break;
    }
    
    case 2: {
      self.imageView.image = [UIImage imageNamed:@"response_history.png"];
      break;
    }
      
    default:
      break;
  }
}


#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Server Overview", @"Server Overview Title");
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];

  [self updateView];
}

- (void)viewDidUnload
{
  [self setImageView:nil];
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
