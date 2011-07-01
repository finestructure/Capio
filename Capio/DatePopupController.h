//
//  DatePopupController.h
//  Capio
//
//  Created by Sven A. Schmidt on 30.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DatePopupControllerDelegate <NSObject>

- (void)cancel:(id)sender;
- (void)done:(id)sender;

@end


@interface DatePopupController : UIViewController {
  UIDatePicker *_datePicker;
}


@property (nonatomic, weak) id<DatePopupControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
