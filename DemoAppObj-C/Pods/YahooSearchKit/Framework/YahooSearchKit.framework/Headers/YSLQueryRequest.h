//
//  YSLQueryRequest.h
//  YahooSearchKit
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "YSLSetting.h"

/**
 *  This is the interface that has search query details
 */
@interface YSLQueryRequest : NSObject

/**
 *  Search Query String
 */
@property (nonatomic, readonly) NSString* query;

/**
 *  Timestamp of the search query initiation
 */
@property (nonatomic, readonly) NSDate* timestamp;

/**
 *  Safe search mode
 */
@property (nonatomic, readonly) YSLSafeSearchMode safeSearch;

/**
 *  Location of the user; it might be nil if user disabled sharing location
 */
@property (nonatomic, readonly) CLLocation* location;

/**
 *  Compares to find if the query object is the same an another query object.
 *
 *  @discussion This method can be called to check if the given query object is same as the object. Both query objects
 *              are considered same if query, location, safesearch and timestamp are same.
 *
 *  @param request YSLQueryRequest object
 */
- (BOOL) isEqualToRequest:(YSLQueryRequest *)request;

@end
