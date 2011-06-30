//
//  CapioAppDelegate.m
//  Capio
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CapioAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "MGSplitViewController.h"

@implementation CapioAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize detailViewController = _detailViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Add the split view controller's view to the window and display.
  [self.window addSubview:self.splitViewController.view];
  [self.window makeKeyAndVisible];
	
	[self.rootViewController performSelector:@selector(selectFirstRow) withObject:nil afterDelay:0];
	[self.detailViewController performSelector:@selector(configureView) withObject:nil afterDelay:0];
	
	if (NO) { // whether to allow dragging the divider to move the split.
		self.splitViewController.splitWidth = 15.0; // make it wide enough to actually drag!
		self.splitViewController.allowsDraggingDivider = YES;
	}
	
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
