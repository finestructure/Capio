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

@synthesize fetchQueue = _fetchQueue;


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


- (NSData *)_fetchDocument:(NSString *)doc {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL useLocalTestData = [defaults boolForKey:kUseLocalTestData];
  
  if (useLocalTestData) {
    NSString *path = [[NSBundle mainBundle] pathForResource:doc ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
  } else {
    NSString *baseUrl = [self baseUrl];
    
    if (baseUrl == nil) {
      return [NSArray array];
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
    
    [urlString appendString:@"/dev/"];
    [urlString appendString:doc];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSData dataWithContentsOfURL:url];
  }
}


- (NSDictionary *)fetchDocument:(NSString *)doc {
  NSString *escapedString = [doc stringByReplacingOccurrencesOfString:@"/" withString:kCouchPathSep];
  NSData *data = [self _fetchDocument:escapedString];
  
  if (data == nil) {
    return nil;
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


- (NSDictionary *)fetchDocPath:(NSArray *)pathComponents {
  NSMutableArray *stringComponents = [NSMutableArray array];
  for (id item in pathComponents) {
    if ([item isKindOfClass:[NSString class]]) {
      [stringComponents addObject:item];
    } else if ([item isKindOfClass:[NSDate class]]) {
      NSString *dateString = [[YmdDateFormatter sharedInstance] stringFromDate:item];
      [stringComponents addObject:dateString];
    } else {
      NSException *exception = [NSException exceptionWithName:@"BadPathComponentException" reason:[NSString stringWithFormat:@"Path component %@ cannot be represented as a path string", item] userInfo:nil];
      @throw exception;
    }
  }
  NSString *url = [stringComponents componentsJoinedByString:kCouchPathSep];
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

- (id)init {
  self = [super init];
  if (self) {
    self.fetchQueue = [[NSOperationQueue alloc] init];
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

