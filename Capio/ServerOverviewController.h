//
//  ServerOverviewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 19.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerOverviewController : UIViewController {
  UIImageView *_imageView;
}

- (IBAction)metricsTapped:(id)sender;
- (IBAction)timelineTapped:(id)sender;
- (IBAction)configTapped:(id)sender;
- (IBAction)segmentTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
