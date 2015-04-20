//
//  YSLSearchProgressDelegate.h
//  YahooSearchKit
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSLQueryRequest;
@protocol YSLSearchProtocol;

/**
 *  This is the delegate protocol that an object should comply to, to indicate search results processing progress in header
 */
@protocol YSLSearchProgressDelegate <NSObject>

/**
 *  Tells the delegate the progress of search results processing.
 *
 *  @discussion This delegate method can be called to nofify the progress of the search results processing.
 *
 *  @param progress progress value between 0 and 1
 *  @param request YSLQueryRequest object that corresponds to the progress of search results
 */
- (void) viewController:(UIViewController <YSLSearchProtocol> *)viewController updateProgress:(float)progress forRequest:(YSLQueryRequest*)request;

@end
