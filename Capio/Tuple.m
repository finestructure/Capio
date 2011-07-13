//
//  Tuple.m
//  Capio
//
//  Created by Sven A. Schmidt on 12.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Tuple.h"

@implementation Tuple

@synthesize x = _x;
@synthesize y = _y;


#pragma mark - Workers

+ (NSArray *)addArray:(NSArray *)a1 toArray:(NSArray *)a2 {
  if ([a1 count] != [a2 count]) {
    [NSException raise:@"Argument Error" format:@"Array counts must be equal"];
  }
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[a1 count]];
  [a1 enumerateObjectsUsingBlock:^(Tuple *i, NSUInteger idx, BOOL *stop) {
    Tuple *sum = [[Tuple alloc] init];
    [sum add:i];
    [sum add:[a2 objectAtIndex:idx]];
    [result addObject:sum];
  }];
  return result;
}


- (void)add:(Tuple *)t {
  self.x = [self.x decimalNumberByAdding:t.x];
  self.y = [self.y decimalNumberByAdding:t.y];
}


#pragma mark - Initializers

+ (id)tupleWithX:(NSString *)x y:(NSString *)y {
  id tuple = [[Tuple alloc] initWithX:x y:y];
  return tuple;
}


- (id)initWithX:(NSString *)x y:(NSString *)y {
  self = [super init];
  if (self) {
    self.x = [NSDecimalNumber decimalNumberWithString:x];
    self.y = [NSDecimalNumber decimalNumberWithString:y];
  }

  return self;
}


- (id)init {
  self = [super init];
  if (self) {
    self.x = [NSDecimalNumber zero];
    self.y = [NSDecimalNumber zero];
  }
  
  return self;
}

@end
