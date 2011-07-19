//
//  AppListCell.m
//  Capio
//
//  Created by Sven A. Schmidt on 04.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppListCell.h"

@implementation AppListCell

@synthesize appName = _appName;
@synthesize ragRed = _ragRed;
@synthesize ragAmber = _ragAmber;
@synthesize amberImage = _amberImage;
@synthesize redImage = _redImage;

const CGFloat kZeroValueAlpha = 0.3;

- (void)setRedRagValue:(NSUInteger)value {
  self.ragRed.text = [NSString stringWithFormat:@"%d", value];
  if (value > 0) {
    self.ragRed.alpha = 1;
    self.redImage.alpha = 1;
  } else {
    self.ragRed.alpha = kZeroValueAlpha;
    self.redImage.alpha = kZeroValueAlpha;
  }
}

- (void)setAmberRagValue:(NSUInteger)value {
  self.ragAmber.text = [NSString stringWithFormat:@"%d", value];
  if (value > 0) {
    self.ragAmber.alpha = 1;
    self.amberImage.alpha = 1;
  } else {
    self.ragAmber.alpha = kZeroValueAlpha;
    self.amberImage.alpha = kZeroValueAlpha;
  }
}


@end
