//
//  AppOverview.m
//  Capio
//
//  Created by Sven A. Schmidt on 30.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppOverview.h"

@implementation AppOverview

@synthesize appName = _appName;
@synthesize appDescription = _appDescription;
@synthesize appOwner = _appOwner;
@synthesize serverCount = _serverCount;
@synthesize reportDate = _reportDate;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
