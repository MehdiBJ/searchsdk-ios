//
//  YSKCustomFooter.h
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import <UIKit/UIKit.h>
#import <YahooSearchKit/YahooSearchKit.h>

typedef NS_ENUM(NSInteger, YSCFooterViewTheme) {
    YSCFooterViewThemeWhite,
    YSCFooterViewThemeDark,
    YSCFooterViewThemeTransparent,
    YSCFooterViewThemeTumblr
};

@interface YSKCustomFooter : UIView <YSLVerticalSelector>

// MARK: YSLVerticalSelector Protocol
@property (nonatomic, readonly) CGFloat maximumHeight;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) id<YSLVerticalSelectorDelegate> verticalSelectorDelegate;

- (instancetype)initWithTheme:(NSUInteger)theme;

@end
