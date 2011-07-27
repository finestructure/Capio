//
//  CapioAppDelegate.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CapioAppDelegate.h"
#import "MGSplitViewController.h"

#import "SecondViewController.h"
#import "BonjourBrowser.h"

@implementation CapioAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  { // set tab bar item for first tab
    UIImage *img = [UIImage imageNamed:@"info.png"];
    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Analysis"
                                                      image:img tag:0];
    self.splitViewController.tabBarItem = tab;
  }
  
  BonjourBrowser *browser = [[BonjourBrowser alloc] initForType:@"_http._tcp"
                                                        inDomain:@"local"
                                                   customDomains:nil
                                        showDisclosureIndicators:NO
                                                showCancelButton:NO];
  browser.navigationBar.barStyle = UIBarStyleBlack;
  { // set tab bar item for config tab
    UIImage *img = [UIImage imageNamed:@"gear.png"];
    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Configuration"
                                                      image:img tag:0];
    browser.tabBarItem = tab;
  }

  self.tabBarController = [[UITabBarController alloc] init];
  
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                           self.splitViewController,
                                           [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil],
                                           browser,
                                           nil];
  
  [self.window addSubview:self.tabBarController.view];
  [self.window makeKeyAndVisible];
    
  return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
