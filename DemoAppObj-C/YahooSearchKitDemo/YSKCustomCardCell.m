//
//  YSKCustomCardCell.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKCustomCardCell.h"

const CGFloat cardTopBottomMargin = 12.0f;
const CGFloat cardLeftRightMargin = 8.0f;

@implementation YSKCustomCardCell

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupStyle];
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

- (void)prepareForReuse {
    self.blogImage.image = nil;
}

#pragma mark - View Hierarchy setup

- (void)addSubviews {
    self.title = [UILabel new];
    self.title.textColor = UIColor.blackColor;
    self.title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    [self.title setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.title];
    
    self.blogImage = [UIImageView new];
    self.blogImage.backgroundColor = UIColor.grayColor;
    [self.blogImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.blogImage.contentMode = UIViewContentModeScaleAspectFill;
    self.blogImage.clipsToBounds = YES;
    [self.contentView addSubview:self.blogImage];
    
    self.caption = [UILabel new];
    self.caption.textColor = UIColor.blackColor;
    self.caption.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    [self.caption setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.caption.numberOfLines = 3;
    [self.contentView addSubview:self.caption];
    
    self.tags = [UILabel new];
    self.tags.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    self.tags.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    [self.tags setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.tags];
    
    self.likeImage = [UIImageView new];
    self.likeImage.image = [UIImage imageNamed:@"like"];
    [self.likeImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.likeImage];
    
    self.reblogImage = [UIImageView new];
    self.reblogImage.image = [UIImage imageNamed:@"reblog"];
    [self.reblogImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.reblogImage];
}

- (void)addConstraints {
    NSDictionary *viewsDictionary = @{@"title": self.title,
                                      @"blogImage": self.blogImage,
                                      @"caption": self.caption,
                                      @"tags": self.tags,
                                      @"likeImage": self.likeImage,
                                      @"reblogImage": self.reblogImage};
    
    // Horizontal Constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[title]-16-|" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blogImage]|" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[caption]-16-|" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[tags]-[reblogImage(19)]-6-[likeImage(19)]-18-|" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.likeImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.reblogImage attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.likeImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tags attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    
    // Vertical Constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[title]-16-[blogImage(210)]-16-[caption]-16-[likeImage(19)]-16-|" options:0 metrics:nil views:viewsDictionary]];
}

- (void)setupStyle {
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame {
    CGRect temp = frame;
    temp.origin.x += cardLeftRightMargin;
    temp.size.width -= 2 * cardLeftRightMargin;
    temp.size.height -= cardTopBottomMargin;
    [super setFrame:temp];
}

@end
