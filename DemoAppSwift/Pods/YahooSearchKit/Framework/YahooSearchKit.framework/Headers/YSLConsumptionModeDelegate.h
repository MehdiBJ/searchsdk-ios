//
//  YSLConsumptionModeDelegate.h
//  YahooSearchKit
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSLSearchProtocol;

/**
 *  This delegate protocol is required to support consumption mode
 */
@protocol YSLConsumptionModeDelegate <NSObject>
/**
 *  Header height that can be used by the object complying to consumption mode, to set scrollview insets
 */
@property (nonatomic,readonly) CGFloat headerHeight;
/**
 *  Footer height that can be used by the object complying to consumption mode, to set scrollview insets
 */
@property (nonatomic,readonly) CGFloat footerHeight;

/**
 *  Tells the delegate that scrolling is about to begin.
 *
 *  @discussion This delegate method can be called to nofify the scrolling content offsets.
 *
 *  @param offset  content offset
 *  @param bottomOffset bottom content offset
 */
- (void) viewController:(UIViewController <YSLSearchProtocol> *)viewController didStartScrollingWithContentOffset:(CGPoint)offset bottomOffset:(CGPoint)bottomOffset;

/**
 *  Tells the delegate when scrolling happens.
 *
 *  @discussion This delegate method can be called to nofify the scrolling content offsets.
 *
 *  @param offset  content offset
 *  @param bottomOffset bottom content offset
 */
- (void) viewController:(UIViewController <YSLSearchProtocol> *)viewController didScrollWithContentOffset:(CGPoint)offset bottomOffset:(CGPoint)bottomOffset;

/**
 *  Tells the delegate when scrolling finishes.
 *
 *  @discussion This delegate method can be called to nofify the scrolling content offsets.
 *
 *  @param offset  content offset
 *  @param bottomOffset bottom content offset
 *  @param velocity velocity when scrolling finishes
 */
- (void) viewController:(UIViewController <YSLSearchProtocol> *)viewController didFinishScrollingWithContentOffet:(CGPoint)offset bottomOffset:(CGPoint)bottomOffset velocity:(CGPoint)velocity;

@end
