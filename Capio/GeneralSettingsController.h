//
//  GeneralSettingsController.h
//  Capio
//
//  Created by Sven A. Schmidt on 01.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralSettingsController : UIViewController {
  UISwitch *_testDataToggle;
  UILabel *_urlLabel;
}

@property (strong, nonatomic) IBOutlet UISwitch *testDataToggle;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

- (IBAction)testDataToggled:(id)sender;

@end
