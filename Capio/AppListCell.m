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

- (void)setRedRagValue:(NSUInteger)value {
  if (value > 0) {
    self.ragRed.hidden = NO;
    self.redImage.hidden = NO;
    self.ragRed.text = [NSString stringWithFormat:@"%d", value];
  } else {
    self.ragRed.hidden = YES;
    self.redImage.hidden = YES;
  }
}

- (void)setAmberRagValue:(NSUInteger)value {
  if (value > 0) {
    self.ragAmber.hidden = NO;
    self.amberImage.hidden = NO;
    self.ragAmber.text = [NSString stringWithFormat:@"%d", value];
  } else {
    self.ragAmber.hidden = YES;
    self.amberImage.hidden = YES;
  }
}


@end
