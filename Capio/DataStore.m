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
#import "Constants.h"


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


- (NSString *)baseUrl {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //NSString *serviceName = [defaults stringForKey:kCouchServiceName];
  NSString *url = [defaults stringForKey:kCouchServiceUrl];
  //NSNetServiceBrowser
  return url;
}


- (NSData *)fetchDocument:(NSString *)doc isLocal:(BOOL)local {
  if (local) {
    NSString *path = [[NSBundle mainBundle] pathForResource:doc ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
  } else {
    NSString *baseUrl = [self baseUrl];
    
    if (baseUrl == nil) {
      NSString *msg = [NSString stringWithFormat:@"Server at '%@' did not available", baseUrl];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Not Available" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
      return [NSArray array];
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
    
    [urlString appendString:@"/dev/"];
    [urlString appendFormat:doc];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSData dataWithContentsOfURL:url];
  }
}


- (NSDictionary *)fetchDocument:(NSString *)doc {
  NSData *data = [self fetchDocument:doc isLocal:YES];
  
  if (data == nil) {
    NSString *msg = [NSString stringWithFormat:@"Server did not return any data"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return [NSArray array];
  }
  
  NSError *error = nil;
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  return  jsonDict;
}


- (NSDictionary *)fetchDocument:(NSString *)doc forDate:(NSDate *)asof {
  NSMutableString *url = [NSMutableString stringWithString:doc];
  [url appendString:kCouchPathSep];
  [url appendString:[[YmdDateFormatter sharedInstance] stringFromDate:asof]];
  
  return [self fetchDocument:url];
}


- (NSArray *)appList {
  NSDictionary *doc = [self fetchDocument:@"apps"];
  
  NSMutableArray *apps = [NSMutableArray array];
  [doc enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = (NSDictionary *)obj;
      AppOverview *item = [[AppOverview alloc] init];
      item.appName = [dict objectForKey:@"app_name"];
      item.appDescription = [dict objectForKey:@"app_description"];
      item.appOwner = [dict objectForKey:@"app_owner"];
      item.serverList = [dict objectForKey:@"server_list"];
      NSString *value = [dict objectForKey:@"report_date"];
      item.reportDate = [[YmdDateFormatter sharedInstance] dateFromString:value];
      item.ragRed = [dict objectForKey:@"red_rag_count"];
      item.ragAmber = [dict objectForKey:@"amber_rag_count"];
      item.ragGreen = [dict objectForKey:@"green_rag_count"];
      item.ragTotal = [NSNumber numberWithUnsignedInteger:[item.ragRed unsignedIntValue] + [item.ragAmber unsignedIntValue] + [item.ragGreen unsignedIntValue]];
      [apps addObject:item];
    }
  }];
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

