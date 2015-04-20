//
//  YSKLandingPageViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKLandingPageViewController.h"

@interface YSKLandingPageViewController ()

@end

@implementation YSKLandingPageViewController

- (void)setBackgroundImage:(UIImage*)newValue {
    _backgroundImage = newValue;
    
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    mainImageView.frame = self.view.frame;
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = mainImageView.bounds;
    [mainImageView addSubview:blurView];
    [self.view addSubview:mainImageView];
}

@end
