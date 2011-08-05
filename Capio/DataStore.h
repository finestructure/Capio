//
//  DataStore.h
//  Capio
//
//  Created by Sven A. Schmidt on 12.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (DataStore *)sharedDataStore;

- (NSUInteger)randomWithMax:(NSUInteger)maxValue;
- (NSArray *)appList;

- (NSArray *)dummyData:(NSUInteger)count;

- (NSDictionary *)fetchDocument:(NSString *)docKey;
- (void)fetchDocument:(NSString *)docKey withCompletionBlock:(void (^)(NSDictionary *doc))block;
- (NSDictionary *)fetchDocument:(NSString *)docKey forDate:(NSDate *)asof;
- (void)fetchDocument:(NSString *)docKey forDate:(NSDate *)date withCompletionBlock:(void (^)(NSDictionary *doc))block;
- (NSDictionary *)fetchDocPath:(NSArray *)pathComponents;

- (NSDictionary *)fetchFromView:(NSString *)viewKey startKey:(id)startKey endKey:(id)endKey;

- (NSArray *)asofDatesForServer:(NSString *)server;

- (NSString *)baseUrl;
- (NSString *)jsonEncode:(id)object;

@property (strong, nonatomic) NSOperationQueue *fetchQueue;

@end
