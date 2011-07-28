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
@synthesize serverList = _serverList;
@synthesize reportDate = _reportDate;
@synthesize ragRed = _ragRed;
@synthesize ragAmber = _ragAmber;
@synthesize ragGreen = _ragGreen;
@synthesize ragTotal = _ragTotal;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
