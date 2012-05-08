//
//  AppConnectionsController.h
//  Capio
//
//  Created by Sven A. Schmidt on 26.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppConnectionsController : UIViewController {
  UIWebView *_webView;
}

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)reload:(id)sender;


@end
