//
//  YSKContentSuggestViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKContentSuggestViewController.h"

@interface YSKContentSuggestViewController () <YSLSearchViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *webSearchButton;
@property (nonatomic, weak) IBOutlet UIButton *imageSearchButton;
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation YSKContentSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtonsAppearance];
}

- (void)updateButtonsAppearance {
    self.borderColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
    self.webSearchButton.layer.borderColor = self.borderColor.CGColor;
    self.imageSearchButton.layer.borderColor = self.borderColor.CGColor;
    self.webSearchButton.layer.borderWidth = 1.0f;
    self.imageSearchButton.layer.borderWidth = 1.0f;
}

- (IBAction)webSearchButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchSuggestions = NO;
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    searchViewController.queryString = @"Augmented Reality";
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)imageSearchButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchSuggestions = NO;
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    [searchViewController setSearchResultTypes:@[YSLSearchResultTypeImage]];
    searchViewController.queryString = @"cats";
    
    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark - YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    [super searchViewControllerDidTapLeftButton:searchViewController];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
