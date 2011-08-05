//
//  PickerPopupController.m
//  Capio
//
//  Created by Sven A. Schmidt on 05.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "PickerPopupController.h"

@implementation PickerPopupController

@synthesize delegate = _delegate;
@synthesize pickerView = _pickerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self setPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)cancel:(id)sender {
  [self.delegate cancel:sender];
}


- (IBAction)done:(id)sender {
  [self.delegate done:sender];
}


@end
