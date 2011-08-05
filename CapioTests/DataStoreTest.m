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


- (void)setUp {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUseLocalTestData];
}


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


- (void)test_jsonEncode {
  NSArray *unencoded = [NSArray arrayWithObjects:@"DBGERLT2073", @"2011-03-02", nil];
  STAssertEqualObjects(@"[\"DBGERLT2073\",\"2011-03-02\"]", [[DataStore sharedDataStore] jsonEncode:unencoded], nil);
}


- (void)test_fetchFromView_1 {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUseLocalTestData];
  id startKey = [NSArray arrayWithObjects:@"DBGERLT2073", @"2011-03-02", nil];
  id endKey = startKey;
  NSDictionary *doc = [[DataStore sharedDataStore] fetchFromView:@"server_asof_dates" startKey:startKey endKey:endKey];
  STAssertNotNil(doc, nil);
  NSNumber *total_rows = [doc objectForKey:@"total_rows"];
  STAssertNotNil(total_rows, nil);
  STAssertEquals(5u, [total_rows unsignedIntValue], nil);
  NSArray *rows = [doc objectForKey:@"rows"];
  STAssertNotNil(rows, nil);
  STAssertEquals(1u, [rows count], nil);
}


- (void)test_fetchFromView_2 {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUseLocalTestData];
  id startKey = [NSArray arrayWithObjects:@"DBGERLT2073", @"", nil];
  id endKey = [NSArray arrayWithObjects:@"DBGERLT2073", @"9", nil];
  NSDictionary *doc = [[DataStore sharedDataStore] fetchFromView:@"server_asof_dates" startKey:startKey endKey:endKey];
  STAssertNotNil(doc, nil);
  NSNumber *total_rows = [doc objectForKey:@"total_rows"];
  STAssertNotNil(total_rows, nil);
  STAssertEquals(5u, [total_rows unsignedIntValue], nil);
  NSArray *rows = [doc objectForKey:@"rows"];
  STAssertNotNil(rows, nil);
  STAssertEquals(2u, [rows count], nil);
}


- (void)test_serverAsofDates {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUseLocalTestData];
  NSArray *rows = [[DataStore sharedDataStore] asofDatesForServer:@"DBGERLT2073"];
  STAssertNotNil(rows, nil);
  STAssertEquals([rows count], 2u, nil);
  STAssertEqualObjects([rows objectAtIndex:0], @"2011-03-02", nil);
  STAssertEqualObjects([rows objectAtIndex:1], @"2011-03-06", nil);
}


- (void)test_serverAsofDates_block {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUseLocalTestData];
  [[DataStore sharedDataStore] asofDatesForServer:@"DBGERLT2073" withCompletionBlock:^(NSArray *dates) {
    STAssertNotNil(dates, nil);
    STAssertEquals([dates count], 2u, nil);
    STAssertEqualObjects([dates objectAtIndex:0], @"2011-03-02", nil);
    STAssertEqualObjects([dates objectAtIndex:1], @"2011-03-06", nil);
  }];
}

@end
