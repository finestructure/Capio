//
//  DataStore.m
//  Capio
//
//  Created by Sven A. Schmidt on 12.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DataStore.h"
#import "AppOverview.h"
#import "Tuple.h"


@implementation DataStore


#pragma mark - Workers

- (NSArray *)dummyData:(NSUInteger)count {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSMutableArray *newData = [NSMutableArray array];
	for (NSUInteger i = 0; i <= count; i++ ) {
		id x = [NSDecimalNumber numberWithDouble:oneDay*i];
		id y = [NSDecimalNumber numberWithUnsignedInteger:[self randomWithMax:count]];
    Tuple *t = [[Tuple alloc] init];
    t.x = x;
    t.y = y;
		[newData addObject:t];
	}
  return newData;
}


- (NSUInteger)randomWithMax:(NSUInteger)maxValue {
  NSUInteger r = arc4random() % (maxValue+1); // [0,maxValue]
  return r;
}


- (NSArray *)appList {
  NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [thisBundle URLForResource:@"app_overview" withExtension:@"plist"];
  
  NSMutableArray *apps = [NSMutableArray array];
  NSArray *data = [NSArray arrayWithContentsOfURL:url];
  for (NSDictionary *dict in data) {
    AppOverview *item = [[AppOverview alloc] init];
    item.appName = [dict objectForKey:@"appName"];
    item.appDescription = [dict objectForKey:@"appDescription"];
    item.appOwner = [dict objectForKey:@"appOwner"];
    item.serverCount = [dict objectForKey:@"serverCount"];
    item.reportDate = [dict objectForKey:@"reportDate"];
    item.ragRed = [dict objectForKey:@"ragRed"];
    item.ragAmber = [dict objectForKey:@"ragAmber"];
    item.ragGreen = [dict objectForKey:@"ragGreen"];
    item.ragTotal = [dict objectForKey:@"ragTotal"];
    [apps addObject:item];
  }
  return apps;
}

#pragma mark - Initializers

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (DataStore *)sharedDataStore {
  static DataStore *sharedDataStore = nil;
  
  if (sharedDataStore) {
    return sharedDataStore;
  }
  
  @synchronized(self) {
    if (!sharedDataStore) {
      sharedDataStore = [[DataStore alloc] init];
    }
    
    return sharedDataStore;
  }
}


@end

