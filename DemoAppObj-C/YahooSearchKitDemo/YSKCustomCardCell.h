//
//  YSKCustomCardCell.h
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT const CGFloat cardTopBottomMargin;
FOUNDATION_EXPORT const CGFloat cardLeftRightMargin;

@interface YSKCustomCardCell : UITableViewCell

// MARK: UI elements
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *caption;
@property (nonatomic, strong) UILabel *tags;
@property (nonatomic, strong) UIImageView *blogImage;
@property (nonatomic, strong) UIImageView *reblogImage;
@property (nonatomic, strong) UIImageView *likeImage;

@end
