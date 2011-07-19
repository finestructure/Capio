//
//  ServerOverviewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 19.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ServerOverviewController.h"
#import "MetricOverviewController.h"

@implementation ServerOverviewController

#pragma mark - Actions


- (IBAction)metricsTapped:(id)sender {
  MetricOverviewController *vc = [[MetricOverviewController alloc] initWithNibName:@"MetricOverview" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Server Overview";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
