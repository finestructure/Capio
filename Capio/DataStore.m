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


- (NSString *)encodeString:(NSString *)unencodedString {
  static NSDictionary *map = nil;
  if (map == nil) {
    map = [NSDictionary dictionaryWithObjectsAndKeys:
           @"%3B", @";",
           @"%2F", @"/",
           @"%3F", @"?",
           @"%3A", @":",
           @"%40", @"@",
           @"%26", @"&",
           @"%3D", @"=",
           @"%2B", @"+",
           @"%24", @"$",
           @"%2C", @",",
           @"%5B", @"[",
           @"%5D", @"]",
           @"%23", @"#",
           @"%21", @"!",
           @"%28", @"(",
           @"%29", @")",
           @"%2A", @"*",
           @"%22", @"\"",
           nil];
  }  
  NSMutableString *encodedString = [unencodedString mutableCopy];
  [map enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [encodedString replaceOccurrencesOfString:key withString:obj options:NSLiteralSearch range:NSMakeRange(0, [encodedString length])];
  }];
    
  return encodedString;
}


- (NSString *)jsonEncode:(id)object {
  if (! [NSJSONSerialization isValidJSONObject:object]) {
    return nil;
  }
  
  NSError *error = nil;
  @try {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error != nil) {
      NSLog(@"Error while encoding JSON: %@", error);
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
  }
  @catch (NSException *exception) {
    NSLog(@"Exception: %@", exception);
    return nil;
  }
}


- (NSDictionary *)_fetchDocument:(NSString *)docKey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL useLocalTestData = [defaults boolForKey:kUseLocalTestData];
  
  NSData *data = nil;
  
  if (useLocalTestData) {
    NSString *path = [[NSBundle mainBundle] pathForResource:docKey ofType:@"json"];
    data = [NSData dataWithContentsOfFile:path];
  } else {
    NSString *baseUrl = [self baseUrl];
    
    if (baseUrl == nil) {
      return [NSDictionary dictionary];
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:baseUrl];
    
    [urlString appendString:@"/dev/"];
    [urlString appendString:docKey];
    NSURL *url = [NSURL URLWithString:urlString];
    data = [NSData dataWithContentsOfURL:url];
  }

  if (data == nil) {
    return nil;
  }
  
  NSError *error = nil;
  @try {
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
      NSLog(@"Error while decoding JSON: %@", error);
    }
    return  jsonDict;
  }
  @catch (NSException *exception) {
    NSLog(@"Exception: %@", exception);
    return nil;
  }
}


- (NSDictionary *)fetchDocument:(NSString *)docKey {
  NSString *escapedString = [self encodeString:docKey];
  NSDictionary *doc = [self _fetchDocument:escapedString];
  return doc;
}


- (void)fetchDocument:(NSString *)docKey withCompletionBlock:(void (^)(NSDictionary *doc))block {
  // avoid reference cycle
  __block __typeof__(self) blockSelf = self;
  [self.fetchQueue addOperationWithBlock:^(void) {
    NSDictionary *doc = [blockSelf fetchDocument:docKey];
    block(doc);
  }];
}


- (NSDictionary *)fetchDocument:(NSString *)docKey forDate:(NSDate *)asof {
  NSMutableString *url = [NSMutableString stringWithString:docKey];
  [url appendString:kCouchPathSep];
  [url appendString:[[YmdDateFormatter sharedInstance] stringFromDate:asof]];
  
  return [self fetchDocument:url];
}


- (void)fetchDocument:(NSString *)docKey forDate:(NSDate *)date withCompletionBlock:(void (^)(NSDictionary *doc))block {
  // avoid reference cycle
  __block __typeof__(self) blockSelf = self;
  [self.fetchQueue addOperationWithBlock:^(void) {
    NSDictionary *doc = [blockSelf fetchDocument:docKey forDate:date];
    block(doc);
  }];
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


- (NSDictionary *)fetchFromView:(NSString *)viewKey startKey:(id)startKey endKey:(id)endKey {
  //@"_design/capm/_view/{viewKey}?startkey={startKey}&endkey={endKey}"
  NSMutableString *viewUrl = [NSMutableString stringWithFormat:@"_design/capm/_view/%@", viewKey];
  [viewUrl appendFormat:@"?startkey=%@", [self encodeString:[self jsonEncode:startKey]]];
  [viewUrl appendFormat:@"&endkey=%@", [self encodeString:[self jsonEncode:endKey]]];
  NSDictionary *doc = [self _fetchDocument:viewUrl];
  return doc;
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

