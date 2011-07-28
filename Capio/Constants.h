//
//  Constants.h
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

// user defaults keys
extern NSString * const kCouchServiceName;
extern NSString * const kCouchServiceUrl;

// notifications
extern NSString * const kCouchServiceUrlChanged;

// other
extern NSString * const kCouchPathSep;


@interface YmdDateFormatter : NSDateFormatter

+ (YmdDateFormatter *)sharedInstance;

@end