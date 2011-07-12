//
//  CapioTests.m
//  CapioTests
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CapioTests.h"
#import "DataStore.h"
#import "Tuple.h"

@implementation CapioTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_example_plist {
  NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [thisBundle URLForResource:@"app_overview" withExtension:@"plist"];
  STAssertNotNil(url, nil);

  NSArray *a = [NSArray arrayWithContentsOfURL:url];
  STAssertNotNil(a, nil);
  STAssertEquals(7, (int)[a count], nil);
  NSDictionary *d1 = [a objectAtIndex:0];
  STAssertNotNil(d1, nil);
  STAssertEqualObjects(@"App X", [d1 objectForKey:@"appName"], nil);
}


- (void)test_appfiler {
  NSArray *apps = [[DataStore sharedDataStore] appList];
  NSString *searchText = @"App";
  NSString *asterisk = @"*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",
                            @"appName", [[asterisk stringByAppendingString:searchText] stringByAppendingString:asterisk]];
  NSArray *results = [apps filteredArrayUsingPredicate:predicate];
  STAssertEquals(3, (int)[results count], nil);
}


- (void)test_tuple_add {
  Tuple *t1 = [[Tuple alloc] init];
  t1.x = [NSDecimalNumber decimalNumberWithString:@"1"];
  t1.y = [NSDecimalNumber decimalNumberWithString:@"2"];
  Tuple *t2 = [[Tuple alloc] init];
  t2.x = [NSDecimalNumber decimalNumberWithString:@"3"];
  t2.y = [NSDecimalNumber decimalNumberWithString:@"4"];
  [t1 add:t2];
  STAssertEqualObjects(t1.x, [NSDecimalNumber decimalNumberWithString:@"4"], @"t1.x");
  STAssertEqualObjects(t1.y, [NSDecimalNumber decimalNumberWithString:@"6"], @"t1.y");
}




@end
