//
//  YSKViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKViewController.h"

@interface YSKViewController () <YSLSearchViewControllerDelegate>

@end

@implementation YSKViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - YSLSearchViewControllerDelegate methods

- (YSLQueryAction)searchViewController:(YSLSearchViewController *)searchViewController actionForQueryString:(NSString *)queryString {
    return YSLQueryActionSearch;
}

@end
