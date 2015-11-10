//
//  YSKCustomHeader.h
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import <UIKit/UIKit.h>
#import <YahooSearchKit/YahooSearchKit.h>

typedef NS_ENUM(NSInteger, YSCHeaderViewMode) {
    YSCHeaderViewNormalMode,
    YSCHeaderViewActiveEditMode,
    YSCHeaderViewPassiveEditMode
};

typedef NS_ENUM(NSInteger, YSCHeaderViewTheme) {
    YSCHeaderViewThemeWhite,
    YSCHeaderViewThemeDark,
    YSCHeaderViewThemeTransparent,
    YSCHeaderViewThemeTumblr
};

@interface YSKCustomHeader : UIView <YSLHeaderProtocol>

// MARK: YSLHeaderProtocol Protocol
@property (nonatomic, copy) NSString* queryString;
@property (nonatomic, weak) id<YSLHeaderDelegate> delegate;
@property (nonatomic, assign) CGFloat progressPercentage;
@property (nonatomic, copy) NSString* placeHolderString;
@property (nonatomic, assign, getter = isEditing) BOOL editing;
@property (nonatomic, readonly) CGFloat maximumHeight;
@property (nonatomic, readonly) CGFloat minimumHeight;

// MARK: YSLHeaderProtocol Protocol
- (void)dismissKeyboard;

- (instancetype)initWithTheme:(NSUInteger)theme;

@end
