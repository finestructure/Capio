//
//  GeneralSettingsController.m
//  Capio
//
//  Created by Sven A. Schmidt on 01.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "GeneralSettingsController.h"

#import "Constants.h"
#import "DataStore.h"


@implementation GeneralSettingsController
@synthesize testDataToggle = _testDataToggle;
@synthesize urlLabel = _urlLabel;


#pragma mark - Actions


- (IBAction)testDataToggled:(id)sender {
  UISwitch *toggle = sender;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:toggle.on forKey:kUseLocalTestData];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kCouchServiceUrlChanged object:self];
}


#pragma mark - Init


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"General", @"General settins category title");
  }
  return self;
}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.testDataToggle.on = [defaults boolForKey:kUseLocalTestData];
  
  self.urlLabel.text = [[DataStore sharedDataStore] baseUrl];
}


- (void)viewDidUnload {
  [self setTestDataToggle:nil];
  [self setUrlLabel:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
	return YES;
}


@end
