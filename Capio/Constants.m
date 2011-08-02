//
//  Constants.m
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Constants.h"

NSString * const kCouchServiceName = @"kCouchServiceName";
NSString * const kCouchServiceUrl = @"kCouchServiceUrl";
NSString * const kUseLocalTestData = @"kUseLocalTestData";

NSString * const kCouchServiceUrlChanged = @"kCouchServiceUrlChanged";

NSString * const kCouchPathSep = @"%2F";


@implementation YmdDateFormatter

- (id)init {
  self = [super init];
  if (self) {
    [self setDateFormat:@"yyyy-MM-dd"];
  }
  
  return self;
}

+ (YmdDateFormatter *)sharedInstance {
  static YmdDateFormatter *sharedInstance = nil;
  
  if (sharedInstance) {
    return sharedInstance;
  }
  
  @synchronized(self) {
    if (!sharedInstance) {
      sharedInstance = [[YmdDateFormatter alloc] init];
    }
    
    return sharedInstance;
  }
}

@end
