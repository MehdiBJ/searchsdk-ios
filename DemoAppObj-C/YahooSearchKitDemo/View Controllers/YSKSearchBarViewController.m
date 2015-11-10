//
//  YSKSearchBarViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKSearchBarViewController.h"
#import <YahooSearchKit/YahooSearchKit.h>

@interface YSKSearchBarViewController () <YSLSearchViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *searchBarButton;
@property (nonatomic, weak) IBOutlet UIButton *searchBarImageButton;
@property (nonatomic, weak) IBOutlet UIButton *searchBarMediaButton;
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation YSKSearchBarViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.borderColor = [UIColor colorWithRed:207.0f/255.0f green:207.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
    [self updateButtonAppearance:self.searchBarButton];
    [self updateButtonAppearance:self.searchBarImageButton];
    [self updateButtonAppearance:self.searchBarMediaButton];
}

#pragma mark - Utilities

- (void)updateButtonAppearance:(UIButton*)button {
    button.layer.borderColor = self.borderColor.CGColor;
    button.layer.borderWidth = 1.0f;
}

#pragma mark - UI Action Handlers

- (void)previewDefaultSearchBarButtonTapped:(UIButton*)sender {
    [self presentSearchViewControllerWithResultTypes:nil];
}

- (void)defaultSearchOptionsButtonTapped:(UIView*)sender {
    [self presentSearchViewControllerWithResultTypes:nil];
}

- (void)imageSearchOptionsButtonTapped:(UIButton*)sender {
    [self presentSearchViewControllerWithResultTypes:@[YSLSearchResultTypeImage]];
}

- (void)videoSearchOptionsButtonTapped:(UIButton*)sender {
    [self presentSearchViewControllerWithResultTypes:@[YSLSearchResultTypeImage, YSLSearchResultTypeVideo]];
}

- (void)presentSearchViewControllerWithResultTypes:(NSArray*)resultTypes {
    YSLSearchViewController *searchViewController = [YSLSearchViewController new];
    if (resultTypes) {
        [searchViewController setSearchResultTypes:resultTypes];
    }
    searchViewController.view.backgroundColor = [UIColor whiteColor];
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark - YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    [super searchViewControllerDidTapLeftButton:searchViewController];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (YSLQueryAction)searchViewController:(YSLSearchViewController*)searchViewController actionForQueryString:(NSString*)queryString {
    return YSLQueryActionShowSuggestions;
}

@end
