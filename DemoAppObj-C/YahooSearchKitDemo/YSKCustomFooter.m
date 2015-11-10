//
//  YSKCustomFooter.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKCustomFooter.h"

@interface YSKCustomFooter ()

@property (nonatomic, readwrite) CGFloat maximumHeight;

// MARK: UI elements
@property (nonatomic, strong) NSMutableArray *verticalSelectorItemViews;

// MARK: UIColor for custom themes
@property (nonatomic, strong) UIColor *activeBackgroundColor;
@property (nonatomic, strong) UIColor *inactiveBackgroundColor;
@property (nonatomic, strong) UIColor *activeItemColor;
@property (nonatomic, strong) UIColor *inactiveItemColor;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic) BOOL enableIcon;

@end

@implementation YSKCustomFooter

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initialInitialization];
    }
    return self;
}

- (void)initialInitialization {
    self.maximumHeight = 45.0f;
    self.verticalSelectorItemViews = [NSMutableArray new];
    self.selectedItemIndex = 0;
    
    self.enableIcon = NO;
    
    self.activeBackgroundColor = [UIColor blackColor];
    self.inactiveBackgroundColor = [UIColor grayColor];
    self.activeItemColor = [UIColor whiteColor];
    self.inactiveItemColor = [UIColor whiteColor];
    self.borderColor = [UIColor blackColor];
}

#pragma mark - YSLVerticalSelector Protocol

- (void)setItems:(NSArray*)items {
    _items = items;
    
    for (id verticalSelectorItemView in self.verticalSelectorItemViews) {
        [verticalSelectorItemView removeFromSuperview];
    }
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *itemView = [self verticalSelectorItemView:idx item:obj];
        [self addSubview:itemView];
    }];
    
    self.selectedItemIndex = 0;
    
    [self setNeedsLayout];
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    
    if (self.verticalSelectorItemViews.count > 0) {
        UIView *oldTabView = self.verticalSelectorItemViews[self.selectedItemIndex];
        UIView *newTabView = self.verticalSelectorItemViews[selectedItemIndex];
        NSArray *oldChildViews = [oldTabView.subviews[0] subviews];
        
        [oldChildViews enumerateObjectsUsingBlock:^(UIView *childView, NSUInteger idx, BOOL *stop) {
            childView.tintColor = self.inactiveItemColor;
        }];
        
        NSArray *newChildViews = [newTabView.subviews[0] subviews];
        [newChildViews enumerateObjectsUsingBlock:^(UIView *childView, NSUInteger idx, BOOL *stop) {
            childView.tintColor = self.activeItemColor;
        }];

        oldTabView.backgroundColor = self.inactiveBackgroundColor;
        newTabView.backgroundColor = self.activeBackgroundColor;
    }
    _selectedItemIndex = selectedItemIndex;
}

#pragma mark - View hierarchy layout setup

- (void)layoutSubviews {

    // Border
    UIView *border = [UIView new];
    border.backgroundColor = self.borderColor;
    [border setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:border];
    
    CGFloat widthForEachView = 0.0f;
    NSUInteger selectorItemsCount = self.items.count;
    if (selectorItemsCount > 0) {
        widthForEachView = self.frame.size.width / selectorItemsCount;
    }
    
    [self.verticalSelectorItemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(widthForEachView, self.frame.size.height);
        frame.origin.x = widthForEachView * idx;
        UIView *aView = (UIView*)obj;
        aView.frame = frame;
    }];
    
    NSDictionary *viewsDictionary = @{@"border":border};

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[border]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[border(1)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary]];
}

#pragma mark - Individiual Selector View Setup

- (UIView*)verticalSelectorItemView:(NSUInteger)index item:(YSLVerticalSelectorItem*)item {
    
    UIView *tabView = nil;

    if (index < self.verticalSelectorItemViews.count) {
        tabView = self.verticalSelectorItemViews[index];
    } else {
        tabView = [UIView new];
        tabView.backgroundColor = self.inactiveBackgroundColor;
        tabView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UIView *contentView = [UIView new];
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Icon
        UIImageView *verticalSelectorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Web.png"]];
        if (self.enableIcon) {
            if (item.searchResultType == YSLSearchResultTypeWeb) {
                verticalSelectorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Web.png"]];
            } else if (item.searchResultType == YSLSearchResultTypeImage) {
                verticalSelectorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image.png"]];
            } else if (item.searchResultType == YSLSearchResultTypeVideo) {
                verticalSelectorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Video.png"]];
            }
            verticalSelectorIcon.image = [verticalSelectorIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [verticalSelectorIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
            verticalSelectorIcon.tintColor = self.inactiveItemColor;
        }
        
        // Title Button
        UIButton *verticalSelector = [UIButton buttonWithType:UIButtonTypeSystem];
        [verticalSelector setTranslatesAutoresizingMaskIntoConstraints:NO];
        verticalSelector.tag = index;
        verticalSelector.exclusiveTouch = YES;
        [verticalSelector setTitle:item.title forState:UIControlStateNormal];
        verticalSelector.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
        verticalSelector.titleLabel.textAlignment = NSTextAlignmentLeft;
        verticalSelector.tintColor = self.inactiveItemColor;
        [verticalSelector addTarget:self action:@selector(verticalSelectorItemClicked:) forControlEvents:UIControlEventTouchDown];
        
        // View Hierarchy
        [tabView addSubview:contentView];
        [contentView addSubview:verticalSelector];
        
        if (self.enableIcon) {
            [contentView addSubview:verticalSelectorIcon];
        }
        
        // Constraints
        NSDictionary *viewsDictionary = @{@"contentView": contentView,
                                          @"tabView": tabView,
                                          @"icon": verticalSelectorIcon,
                                          @"label": verticalSelector};
        
        // Constrains for the image icon
        if (self.enableIcon) {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[icon(20)]-3-[label]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary]];
            
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[icon(20)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary]];
            
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:verticalSelectorIcon
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
            
        } else {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary]];
        }
        

        // Constrains for the button
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:verticalSelector
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f
                                                                 constant:0.0f]];

        // Constraints for the contentView
        [tabView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:tabView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0f
                                                                 constant:0.0f]];

        [tabView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:tabView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f
                                                                 constant:0.0f]];

        [tabView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:tabView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0f
                                                                 constant:0.0f]];

        [self.verticalSelectorItemViews addObject:tabView];
    }
    return tabView;
}

#pragma mark - UIButton Target Action

- (void)verticalSelectorItemClicked:(UIButton*)sender {
    self.selectedItemIndex = sender.tag;
    [self.verticalSelectorDelegate verticalSelector:self selectItemAtIndex:sender.tag];
}

#pragma mark - Custom initialization

- (instancetype)initWithTheme:(NSUInteger)theme {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self initialInitialization];
        
        switch (theme) {
            case YSCFooterViewThemeDark:
                self.activeBackgroundColor = [UIColor colorWithRed:71.0f/255.0f green:71.0f/255.0f blue:72.0f/255.0f alpha:1.0f];
                self.activeItemColor = [UIColor whiteColor];
                self.inactiveBackgroundColor = [UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:27.0f/255.0f alpha:1.0f];
                self.inactiveItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                self.borderColor = [UIColor clearColor];
                self.enableIcon = YES;
                break;
            case YSCFooterViewThemeWhite:
                self.activeBackgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
                self.activeItemColor = [UIColor colorWithRed:64.0f/255.0f green:0.0f blue:144.0f/255.0f alpha:1.0f];
                self.inactiveBackgroundColor = [UIColor whiteColor];
                self.inactiveItemColor = [UIColor colorWithRed: 0.0f green: 0.0f blue:0.0f alpha:0.6f];
                self.borderColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
                break;
            case YSCFooterViewThemeTransparent:
                self.activeBackgroundColor = [UIColor colorWithRed:94.0/255.0 green:118.0/255.0 blue:162.0/255.0 alpha:1.0f];
                self.activeItemColor = [UIColor whiteColor];
                self.inactiveBackgroundColor = [UIColor colorWithRed:111.0f/255.0f green:139.0f/255.0f blue: 191.0f/255.0f alpha:1.0f];
                self.inactiveItemColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                self.borderColor = [UIColor clearColor];
                self.enableIcon = YES;
                break;
            case YSCFooterViewThemeTumblr:
                self.activeBackgroundColor = [UIColor colorWithRed:58.0/255.0 green:75.0/255.0 blue:95.0/255.0 alpha:1.0f];
                self.activeItemColor = [UIColor whiteColor];
                self.inactiveBackgroundColor = [UIColor colorWithRed:58.0/255.0 green:75.0/255.0 blue:95.0/255.0 alpha:1.0f];
                self.inactiveItemColor = [UIColor colorWithRed:135.0/255.0 green:147.0/255.0 blue:158.0/255.0 alpha:1.0f];
                self.borderColor = [UIColor clearColor];
                break;
        }
    }
    return self;
}

@end
