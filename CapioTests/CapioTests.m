//
//  CapioTests.m
//  CapioTests
//
//  Created by Sven A. Schmidt on 29.06.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "CapioTests.h"
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


- (void)test_tuple_add {
  Tuple *t1 = [Tuple tupleWithX:@"1" y:@"2"];
  Tuple *t2 = [Tuple tupleWithX:@"3" y:@"4"];
  [t1 add:t2];
  STAssertEqualObjects(t1.x, [NSDecimalNumber decimalNumberWithString:@"4"], @"t1.x");
  STAssertEqualObjects(t1.y, [NSDecimalNumber decimalNumberWithString:@"6"], @"t1.y");
}


- (void)test_tuple_sum {
  NSMutableArray *a1 = [NSMutableArray array];
  NSMutableArray *a2 = [NSMutableArray array];
  for (NSUInteger i = 0; i < 10; ++i) {
    {
      NSString *x = [NSString stringWithFormat:@"%d", i];
      NSString *y = [NSString stringWithFormat:@"%d", i+1];
      [a1 addObject:[Tuple tupleWithX:x y:y]];
    }
    {
      NSString *x = [NSString stringWithFormat:@"%d", i];
      NSString *y = [NSString stringWithFormat:@"%d", i+11];
      [a2 addObject:[Tuple tupleWithX:x y:y]];
    }
  }
  NSArray *sum = [Tuple ySumArray:a1 andArray:a2];
  STAssertEquals(10u, [sum count], @"sum count");
  STAssertEqualObjects(@"0", [[(Tuple *)[sum objectAtIndex:0] x] stringValue], @"sum item");
  STAssertEqualObjects(@"1", [[(Tuple *)[sum objectAtIndex:1] x] stringValue], @"sum item");
  STAssertEqualObjects(@"9", [[(Tuple *)[sum objectAtIndex:9] x] stringValue], @"sum item");
  
  STAssertEqualObjects(@"12", [[(Tuple *)[sum objectAtIndex:0] y] stringValue], @"sum item");
  STAssertEqualObjects(@"14", [[(Tuple *)[sum objectAtIndex:1] y] stringValue], @"sum item");
  STAssertEqualObjects(@"30", [[(Tuple *)[sum objectAtIndex:9] y] stringValue], @"sum item");
}


- (void)test_rest {
  NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5984/dev/apps"];
  NSData *data = [NSData dataWithContentsOfURL:url];
  NSError *error = nil;
  NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  STAssertNil(error, @"error must be nil");
  STAssertNotNil(obj, @"obj must not be nil");
  NSDictionary *app = [obj objectForKey:@"DB Caprep"];
  STAssertEqualObjects(@"Steven Götäpp", [app objectForKey:@"app_owner"], nil);
}


@end
