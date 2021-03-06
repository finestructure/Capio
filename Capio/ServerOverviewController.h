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
  UILabel *_serverName;
  UILabel *_reportDate;
}

- (IBAction)metricsTapped:(id)sender;
- (IBAction)timelineTapped:(id)sender;
- (IBAction)configTapped:(id)sender;
- (IBAction)segmentTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *serverName;
@property (strong, nonatomic) IBOutlet UILabel *reportDate;

@end
