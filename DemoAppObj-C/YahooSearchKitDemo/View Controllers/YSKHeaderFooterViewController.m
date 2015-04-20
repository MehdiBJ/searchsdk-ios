//
//  YSKHeaderFooterViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKHeaderFooterViewController.h"
#import "YSKCustomHeader.h"
#import "YSKCustomFooter.h"
#import "YSKLandingPageViewController.h"
#import <YahooSearchKit/YahooSearchKit.h>

@interface YSKHeaderFooterViewController () <YSLSearchViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *whiteThemeButton;
@property (nonatomic, weak) IBOutlet UIButton *darkThemeButton;
@property (nonatomic, weak) IBOutlet UIButton *transparentThemeButton;

@property (nonatomic,strong) UIColor *borderColor;

@end

@implementation YSKHeaderFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.borderColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
}

#pragma mark - UI Action Handlers

- (IBAction)whiteThemeButtonTapped:(id)sender {
    
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    YSKCustomHeader *headerView = [[YSKCustomHeader alloc] initWithTheme:YSCHeaderViewThemeWhite];
    searchViewController.headerView = headerView;
    YSKCustomFooter *footerView = [[YSKCustomFooter alloc] initWithTheme:YSCFooterViewThemeWhite];
    searchViewController.footerView = footerView;
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)darkThemeButtonTapped:(id)sender {
    
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    YSKCustomHeader *headerView = [[YSKCustomHeader alloc] initWithTheme:YSCHeaderViewThemeDark];
    searchViewController.headerView = headerView;
    YSKCustomFooter *footerView = [[YSKCustomFooter alloc] initWithTheme:YSCFooterViewThemeDark];
    searchViewController.footerView = footerView;
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)transparentThemeTapped:(id)sender {
    
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableTransparency = YES;
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    
    // Screenshot
    /*
     UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.mainScreen().scale)
     self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
     var snapshot:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     */
    
    UIImage *snapshot = [UIImage imageNamed:@"BGimage.png"];
    
    // Setting it to landing page
    YSKLandingPageViewController *landingPage = [YSKLandingPageViewController new];
    landingPage.backgroundImage = snapshot;
    searchViewController.landingPageViewController = landingPage;
    searchViewController.hideLandingPage = NO;
    
    searchViewController.delegate = self;
    YSKCustomHeader *headerView = [[YSKCustomHeader alloc] initWithTheme:YSCHeaderViewThemeTransparent];
    searchViewController.headerView = headerView;
    YSKCustomFooter *footerView = [[YSKCustomFooter alloc] initWithTheme:YSCFooterViewThemeTransparent];
    searchViewController.footerView = footerView;
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark - YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (YSLQueryAction)searchViewController:(YSLSearchViewController*)searchViewController actionForQueryString:(NSString*)queryString {
    return YSLQueryActionDefault;
}

@end
