//
//  CapioAppDelegate.h
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGSplitViewController;

@interface CapioAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet MGSplitViewController *splitViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
