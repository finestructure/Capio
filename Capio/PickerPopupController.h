//
//  PickerPopupController.h
//  Capio
//
//  Created by Sven A. Schmidt on 05.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopupControllerDelegate.h"


@interface PickerPopupController : UIViewController {
  UIPickerView *_pickerView;
}

@property (nonatomic, weak) id<PopupControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
