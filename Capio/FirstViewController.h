//
//  FirstViewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@interface FirstViewController : UIViewController {
  MGSplitViewController *splitViewController;
}

@property (nonatomic, retain) IBOutlet MGSplitViewController *splitViewController;

@end
