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
#import "Constants.h"

@implementation DataStoreTest


- (void)test_fetchDocument {
  NSDictionary *doc = [[DataStore sharedDataStore] fetchDocument:@"apps"];
  STAssertNotNil(doc, nil);
  // 6 apps + _id
  STAssertEquals(7u, [doc count], nil);
}


- (void)test_fetchDocument_forDate {
  NSDate *asof = [[YmdDateFormatter sharedInstance] dateFromString:@"2011-03-02"];
  NSDictionary *doc = [[DataStore sharedDataStore] fetchDocument:@"DBGERLT2073" forDate:asof];
  STAssertNotNil(doc, nil);
  STAssertEquals(7u, [doc count], nil);
  STAssertNotNil([doc objectForKey:@"_id"], nil);
  STAssertEqualObjects(@"DBGERLT2073/2011-03-02", [doc objectForKey:@"_id"], nil);
}


- (void)test_fetchDocPath {
  NSArray *path = [NSArray arrayWithObjects:
                   @"DBGERLT2073",
                   [[YmdDateFormatter sharedInstance] dateFromString:@"2011-03-02"],
                   @"cpu",
                   nil];
  NSDictionary *doc = [[DataStore sharedDataStore] fetchDocPath:path];
  STAssertNotNil(doc, nil);
  STAssertEquals(15u, [doc count], nil);
  STAssertNotNil([doc objectForKey:@"_id"], nil);
  STAssertEqualObjects(@"DBGERLT2073/2011-03-02/cpu", [doc objectForKey:@"_id"], nil);
}


- (void)test_fetch_Document_withCompletionBlock {
  [[DataStore sharedDataStore] fetchDocument:@"apps" withCompletionBlock:^(NSDictionary *doc) {
    STAssertNotNil(doc, nil);
  }];
}


- (void)test_fetch_Document_forDate_withCompletionBlock {
  NSDate *asof = [[YmdDateFormatter sharedInstance] dateFromString:@"2011-03-02"];
  [[DataStore sharedDataStore] fetchDocument:@"DBGERLT2073" forDate:asof withCompletionBlock:^(NSDictionary *doc) {
    STAssertNotNil(doc, nil);
  }];
}


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


- (void)test_appfilter {
  NSArray *apps = [[DataStore sharedDataStore] appList];
  NSString *searchText = @"App";
  NSString *asterisk = @"*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",
                            @"appName", [[asterisk stringByAppendingString:searchText] stringByAppendingString:asterisk]];
  NSArray *results = [apps filteredArrayUsingPredicate:predicate];
  NSLog(@"results: %@", results);
  STAssertEquals(2, (int)[results count], nil);
}


@end
