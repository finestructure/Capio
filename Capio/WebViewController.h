//
//  WebViewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 04.08.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController {
  UIWebView *_webView;
}

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)reload:(id)sender;

@end
