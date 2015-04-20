//
//  YSLSearchProtocol.h
//  YahooSearchKit
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSLQueryRequest;
@class YSLVerticalSelectorItem;
@protocol YSLSearchProgressDelegate;
@protocol YSLConsumptionModeDelegate;

/**
 *  This protocol is required for a UIViewController to support showing custom search results
 */
@protocol YSLSearchProtocol

/**
 *  YSLQueryRequest object that contains current search query related info
 */
@property (nonatomic, strong) YSLQueryRequest* queryRequest;

/**
 *  Footer Item that should be displayed in Footer for this custom tab
 */
@property (nonatomic, readonly) YSLVerticalSelectorItem *verticalSelectorItem;

/**
 *  This method is called to load search results in this custom tab. Note that this may be called
 *  multiple times; its upto the custom tab to check if the queryRequest is changed before loading the results
 */
- (void) startLoading;

/**
 *  This method is called to stop loading search results in this custom tab. If the user changed the search query, 
 *  this will be called to stop loading the previous search results. Its upto the custom tab to honor this method call.
 */
- (void) stopLoading;

/**
 *  This delegate will be set by the SDK so that custom tab can inform the progress, if it wants to, so that
 *  the progress bar is shown accordingly in the Header
 */
@property (nonatomic, weak) id<YSLSearchProgressDelegate> searchProgressDelegate;
/**
 *  This delegate will be set by the SDK so that custom tab can inform the scroll progress, if it wants to, so that
 *  the consumption mode will be supported ie., header and footer will animate to show/hide based on the user scrolling content.
 */
@property (nonatomic, weak) id<YSLConsumptionModeDelegate> consumptionModeDelegate;

@optional
/**
 *  If custom tab supports scroll view and it wants to support scrollToTop feature when in search container, 
 *  this getter should be implemented.
 */
@property (nonatomic, readonly) UIScrollView * mainScrollView;

@end
