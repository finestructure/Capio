//
//  PickerPopupController.h
//  Capio
//
//  Created by Sven A. Schmidt on 05.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PickerPopupController : UIViewController {
  UIPickerView *_pickerView;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
