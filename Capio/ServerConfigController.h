//
//  ServerConfigController.h
//  Capio
//
//  Created by Sven A. Schmidt on 26.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerConfigController : UIViewController {
  UITableView *_tableview;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end
