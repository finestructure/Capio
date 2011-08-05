//
//  PickerPopupController.h
//  Capio
//
//  Created by Sven A. Schmidt on 05.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickerPopupControllerDelegate <NSObject>

- (void)cancel:(id)sender;
- (void)done:(id)sender;

@end


@interface PickerPopupController : UIViewController {
  UIPickerView *_pickerView;
}

@property (nonatomic, weak) id<PickerPopupControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;


@end
