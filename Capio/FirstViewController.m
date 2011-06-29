//
//  FirstViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "FirstViewController.h"
#import "AppList.h"
#import "AppOverview.h"

@implementation FirstViewController

@synthesize splitViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  //AppList *vc1 = [[AppList alloc] initWithNibName:@"AppList" bundle:nil];
  //AppOverview *vc2 = [[AppOverview alloc] initWithNibName:@"AppOverview" bundle:nil];

  splitViewController = [[MGSplitViewController alloc] init];
  splitViewController.viewControllers = [NSArray arrayWithObjects:
                                         [[AppList alloc] initWithNibName:@"AppList" bundle:nil],
                                         [[AppOverview alloc] initWithNibName:@"AppOverview" bundle:nil],
                                         nil];

  [self.view addSubview:splitViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return YES;
}

@end
