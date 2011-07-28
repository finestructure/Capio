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

- (NSDictionary *)fetchDocument:(NSString *)doc;
- (NSDictionary *)fetchDocument:(NSString *)doc forDate:(NSDate *)asof;

@end
