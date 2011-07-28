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
}

@property (strong, nonatomic) IBOutlet UIView *appArrowView;
@property (strong, nonatomic) IBOutlet UIView *tabArrowView;

@end
