//
//  YSKCustomVerticalViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKCustomTabsViewController.h"
#import "YSKCustomHeader.h"
#import "YSKCustomFooter.h"
#import "YSKLandingPageViewController.h"
#import <YahooSearchKit/YahooSearchKit.h>
#import "YSKCustomVertical.h"

@interface YSKCustomTabsViewController () <YSLSearchViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *firstTumblrButton;
@property (nonatomic, weak) IBOutlet UIButton *secondTumblrButton;

@property (nonatomic,strong) UIColor *borderColor;

@end

@implementation YSKCustomTabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.borderColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
}

#pragma mark - UI Action Handlers

- (IBAction)firstTumblrButtonTapped:(id)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableTransparency = YES;
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    [[YSLSetting sharedSetting] registerSearchResultClass:[YSKCustomVertical class] forType:@"tumblr"];
    
    // Setting it to landing page
    YSKLandingPageViewController *landingPage = [YSKLandingPageViewController new];
    landingPage.view.backgroundColor = [UIColor colorWithRed:54.0f/255.0f green:70.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
    searchViewController.landingPageViewController = landingPage;
    searchViewController.hideLandingPage = NO;
    
    [searchViewController setSearchResultTypes:@[@"tumblr",
                                                 YSLSearchResultTypeWeb]];
    
    searchViewController.delegate = self;
    YSKCustomHeader *headerView = [[YSKCustomHeader alloc] initWithTheme:YSCHeaderViewThemeTumblr];
    searchViewController.headerView = headerView;
    YSKCustomFooter *footerView = [[YSKCustomFooter alloc] initWithTheme:YSCFooterViewThemeTumblr];
    searchViewController.footerView = footerView;
    searchViewController.queryString = @"yahoo";
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)secondTumblrButtonTapped:(id)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableTransparency = YES;
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    [[YSLSetting sharedSetting] registerSearchResultClass:[YSKCustomVertical class] forType:@"tumblr"];
    
    // Setting it to landing page
    YSKLandingPageViewController *landingPage = [YSKLandingPageViewController new];
    landingPage.view.backgroundColor = [UIColor colorWithRed:54.0f/255.0f green:70.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
    searchViewController.landingPageViewController = landingPage;
    searchViewController.hideLandingPage = NO;
    
    [searchViewController setSearchResultTypes:@[YSLSearchResultTypeWeb,
                                                 YSLSearchResultTypeImage,
                                                 YSLSearchResultTypeVideo,
                                                 @"tumblr"]];
    
    searchViewController.delegate = self;
    YSKCustomHeader *headerView = [[YSKCustomHeader alloc] initWithTheme:YSCHeaderViewThemeTumblr];
    searchViewController.headerView = headerView;
    YSKCustomFooter *footerView = [[YSKCustomFooter alloc] initWithTheme:YSCFooterViewThemeTumblr];
    searchViewController.footerView = footerView;
    searchViewController.queryString = @"yahoo";
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark - YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    [[YSLSetting sharedSetting] deregisterSearchResultType:@"tumblr"];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (YSLQueryAction)searchViewController:(YSLSearchViewController*)searchViewController actionForQueryString:(NSString*)queryString {
    return YSLQueryActionDefault;
}


@end
