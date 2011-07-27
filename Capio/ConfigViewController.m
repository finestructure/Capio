//
//  ConfigViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ConfigViewController.h"
#import "BonjourBrowser.h"

@implementation ConfigViewController
@synthesize navigationController = _navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      UIImage *img = [UIImage imageNamed:@"gear.png"];
      UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Configuration" image:img tag:2];
      self.tabBarItem = tab;
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

- (void)viewDidLoad {
  [super viewDidLoad];

  BonjourBrowser *browser = [[BonjourBrowser alloc] initForType:@"_http._tcp"
                                                       inDomain:@"local"
                                                  customDomains:nil
                                       showDisclosureIndicators:NO
                                               showCancelButton:NO];
  browser.navigationBar.barStyle = UIBarStyleBlack;

  self.navigationController = browser;
  [self.view addSubview:browser.view];
}

- (void)viewDidUnload
{
  [self setNavigationController:nil];
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
