//
//  AppOverview.h
//  Capio
//
//  Created by Sven A. Schmidt on 30.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOverview : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appDescription;
@property (nonatomic, strong) NSString *appOwner;
@property (nonatomic, strong) NSNumber *serverCount;
@property (nonatomic, strong) NSDate *reportDate;

@end
