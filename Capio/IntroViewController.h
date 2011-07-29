//
//  IntroViewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 28.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController {
  UIView *_appArrowView;
  UIView *_tabArrowView;
  UIButton *_versionButton;
}

@property (assign) CGRect origFrameAppArrowView;
@property (assign) CGRect origFrameTabArrowView;

@property (strong, nonatomic) IBOutlet UIView *appArrowView;
@property (strong, nonatomic) IBOutlet UIView *tabArrowView;
@property (strong, nonatomic) IBOutlet UIButton *versionButton;

- (IBAction)versionTapped:(id)sender;

@end
