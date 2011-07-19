//
//  AppListCell.h
//  Capio
//
//  Created by Sven A. Schmidt on 04.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppListCell : UITableViewCell {
  UILabel *_appName;
  UILabel *_ragRed;
  UILabel *_ragAmber;
  UIImageView *_amberImage;
  UIImageView *_redImage;
}

@property (nonatomic, strong) IBOutlet UILabel *appName;
@property (nonatomic, strong) IBOutlet UILabel *ragRed;
@property (nonatomic, strong) IBOutlet UILabel *ragAmber;

@property (nonatomic, strong) IBOutlet UIImageView *amberImage;
@property (nonatomic, strong) IBOutlet UIImageView *redImage;

- (void)setRedRagValue:(NSUInteger)value;
- (void)setAmberRagValue:(NSUInteger)value;

@end
