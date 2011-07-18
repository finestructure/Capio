//
//  DataStoreTest.m
//  Capio
//
//  Created by Sven A. Schmidt on 18.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DataStoreTest.h"
#import "DataStore.h"
#import "AppOverview.h"

@implementation DataStoreTest


- (void)test_appList {
  NSArray *apps = [[DataStore sharedDataStore] appList];
  STAssertEquals(6u, [apps count], nil);
  __block AppOverview *appX = nil;
  [apps enumerateObjectsUsingBlock:^(AppOverview *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.appName isEqualToString:@"App X"]) {
      appX = obj;
      *stop = YES;
    }
  }];
  STAssertNotNil(appX, nil);
  STAssertEqualObjects(@"App X", appX.appName, nil);
  NSLog(@"date: %@", appX.reportDate);
  STAssertTrue([appX.reportDate isKindOfClass:[NSDate class]], nil);
}


- (void)test_appfiler {
  NSArray *apps = [[DataStore sharedDataStore] appList];
  NSString *searchText = @"App";
  NSString *asterisk = @"*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",
                            @"appName", [[asterisk stringByAppendingString:searchText] stringByAppendingString:asterisk]];
  NSArray *results = [apps filteredArrayUsingPredicate:predicate];
  NSLog(@"results: %@", results);
  STAssertEquals(3, (int)[results count], nil);
}



@end
