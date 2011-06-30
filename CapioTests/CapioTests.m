//
//  CapioTests.m
//  CapioTests
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CapioTests.h"
#import "AppOverview.h"

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
  STAssertEquals(2, (int)[a count], nil);
  NSDictionary *d1 = [a objectAtIndex:0];
  STAssertNotNil(d1, nil);
  STAssertEqualObjects(@"App X", [d1 objectForKey:@"appName"], nil);
}

@end
