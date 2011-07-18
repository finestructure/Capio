//
//  DataStoreTest.m
//  Capio
//
//  Created by Sven A. Schmidt on 18.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DataStoreTest.h"
#import "DataStore.h"

@implementation DataStoreTest

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
