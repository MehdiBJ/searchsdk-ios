//
//  YSLVerticalSelector.h
//  YahooSearchLibrary
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSLVerticalSelectorDelegate;

@protocol YSLVerticalSelector <NSObject>

/**
 * This is the array of items represented on the vertical selector.
 *
 * @discussion The items are instances of YSLVerticalSelectorItem, and appear in the same order arranged in the array. Changes to this property will not be animated.
 */
@property(nonatomic, copy) NSArray *items;

/**
 * This is the index of the currently selected item.
 */
@property(nonatomic, assign) NSUInteger selectedItemIndex;

/**
 * This is the maximum possible height of the vertical selector given to the Search View Controller.
 */
@property (nonatomic, readonly) CGFloat maximumHeight;

/**
 *  The footer view's delegate object.
 *
 *  @discussion The delegate must adopt the YSLVerticalSelectorDelegate protocol. The delegate will be used whenever the user selects a particular vertical item.
 */
@property (nonatomic,weak) id<YSLVerticalSelectorDelegate> verticalSelectorDelegate;

@end

@protocol YSLVerticalSelectorDelegate <NSObject>

/**
 * Tells delegate a new item is been selected.
 *
 * @param verticalSelector vertical selector instance that conforms to the YSLVerticalSelector protocol
 * @param index            index of the item being selected
 */
- (void) verticalSelector:(id<YSLVerticalSelector>)verticalSelector selectItemAtIndex:(NSUInteger)index;

@end


@interface YSLVerticalSelectorItem : NSObject

/**
 * This is the title displayed in the view.
 */
@property (nonatomic, strong) NSString* title;

/**
 * This is the searchResultType associated with this vertical selector item.
 */
@property (nonatomic, strong) NSString* searchResultType;

@end
