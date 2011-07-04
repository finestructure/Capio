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
}

@property (nonatomic, strong) IBOutlet UILabel *appName;
@property (nonatomic, strong) IBOutlet UILabel *ragRed;

@end
