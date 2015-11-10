//
//  YSLHeaderProtocol.h
//  YahooSearchLibrary
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSLHeaderDelegate;

@protocol YSLHeaderProtocol <NSObject>

/**
 *  This is the queryString in the search input box, or of something similar in the header view.
 *
 *  @discussion This is the queryString for which the header will display in its view.
 */
@property (nonatomic, copy) NSString* queryString;

/**
 *  The header view's delegate object.
 *
 *  @discussion The delegate must adopt the YSLHeaderDelegate protocol.
 */
@property (nonatomic, weak) id<YSLHeaderDelegate> delegate;

/**
 * This is the percentage used for displaying search progress.
 * 
 * @discussion Ranges from 0.0 - 1.0. 0.0 being not loaded, and 1.0 being fully loaded.
 */
@property (nonatomic, assign) CGFloat progressPercentage;

/**
 *  This is the placeholder string when there is currently no query.
 *
 *  @discussion This is the placeholder string when there is currently no query inputted by the user.
 */
@property (nonatomic, copy) NSString* placeHolderString;

/**
 * This toggles editing mode of the header.
 */
@property (nonatomic, assign, getter = isEditing) BOOL editing;

/**
 * This should called to dismiss the keyboard without exiting out of editing mode.
 */
- (void)dismissKeyboard;

/**
 * This is the maximum possible height of the header given to the Search View Controller.
 */
@property (nonatomic, readonly) CGFloat maximumHeight;

/**
 * This is the minimum possible height of the header given to the Search View Controller.
 */
@property (nonatomic, readonly) CGFloat minimumHeight;

@end

@protocol YSLHeaderDelegate <NSObject>

/**
 *  Tells the delegate that editing is about to begin.
 *
 *  @discussion Implement this delegate method to be notified when the user is about to begin editing queryString.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 *  @param queryString the current query string
 */
- (void) header:(id<YSLHeaderProtocol>)headerView willBeginEditingQueryString:(NSString *)queryString;

/**
 *  Tells the delegate that editing has begun. Search suggestions will be displayed for the given queryString if enabled.
 *
 *  @discussion Implement this delegate method to be notified when the user begins editing the queryString.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 *  @param queryString the current query string
 */
- (void) header:(id<YSLHeaderProtocol>)headerView didBeginEditingQueryString:(NSString *)queryString;

/**
 *  Tells the delegate that queryString has been changed.
 *
 *  @discussion Implement this delegate method to be notified when the user has changed queryString.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 *  @param queryString the current query string
 */
- (void) header:(id<YSLHeaderProtocol>)headerView didChangeQueryString:(NSString *)queryString;

/**
 *  Tells the delegate that editing has ended.
 *
 *  @discussion Implement this delegate method to be notified when the user has ended editing.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 *  @param queryString the current query string
 */
- (void) header:(id<YSLHeaderProtocol>)headerView didEndEditingQueryString:(NSString *)queryString;

/**
 *  Tells the delegate that editing has been canceled.
 *
 *  @discussion Implement this delegate method to be notified when the user canceled out of editing mode.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 *  @param queryString the current query string
 */
- (void) header:(id<YSLHeaderProtocol>)headerView didCancelEditingQueryString:(NSString *)queryString;

/**
 *  Tells the delegate that the cancel button has been tapped.
 *
 *  @discussion Implement this delegate method to be notified when the user has explicitly tapped on the cancel button.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 */
- (void) cancelButtonTappedInHeaderView:(id<YSLHeaderProtocol>)headerView;

/**
 *  Tells the delegate that the left button has been tapped.
 *
 *  @discussion Implement this delegate method to be notified when the user has explicitly tapped on the left button.
 *
 *  @param headerView  header view instance that conforms to the YSLHeaderProtocol protocol
 */
- (void) leftButtonTappedInHeaderView:(id<YSLHeaderProtocol>)headerView;


@end