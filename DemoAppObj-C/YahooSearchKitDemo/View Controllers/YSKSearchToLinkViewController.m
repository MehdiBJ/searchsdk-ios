//
//  YSKSearchToLinkViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKSearchToLinkViewController.h"

@interface YSKSearchToLinkViewController () <YSLSearchViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *searchAPIResponseTextView;
@property (nonatomic, weak) IBOutlet UIButton *webSearchButton;
@property (nonatomic, weak) IBOutlet UIButton *imageSearchButton;
@property (nonatomic, weak) IBOutlet UIButton *videoSearchButton;

@end

@implementation YSKSearchToLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtonsAppearance];
}

- (void)updateButtonsAppearance {
    UIColor *borderColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
    self.webSearchButton.layer.borderColor = borderColor.CGColor;
    self.webSearchButton.layer.borderWidth = 1.0f;
    self.imageSearchButton.layer.borderColor = borderColor.CGColor;
    self.imageSearchButton.layer.borderWidth = 1.0f;
    self.videoSearchButton.layer.borderColor = borderColor.CGColor;
    self.videoSearchButton.layer.borderWidth = 1.0f;
}

#pragma mark - UI helper methods

- (IBAction)searchToLinkButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchSuggestions = NO;
    settings.enableSearchToLink = YES;
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    searchViewController.queryString = @"";
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)searchImageToLinkButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchToLink = YES;
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    [searchViewController setSearchResultTypes:@[YSLSearchResultTypeImage]];
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)searchVideoToLinkButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchToLink = YES;
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    [searchViewController setSearchResultTypes:@[YSLSearchResultTypeVideo]];
    [self presentViewController:searchViewController animated:YES completion:nil];
}

#pragma mark -  YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    [super searchViewControllerDidTapLeftButton:searchViewController];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchViewController:(YSLSearchViewController*)searchViewController didSearchToLink:(YSLSearchToLinkResult*)result {
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *responseString = @"";
    
    if (result.queryString) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"queryString: %@\n", result.queryString]];
    }
    if (result.title) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"title: %@\n", result.title]];
    }
    if (result.shortURL.absoluteString) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"shortURL: %@\n", result.shortURL.absoluteString]];
    }
    if (result.linkDescription) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"linkDescription: %@\n", result.linkDescription]];
    }
    if (result.thumbnailURL.absoluteString) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"thumbnailURL: %@\n", result.thumbnailURL.absoluteString]];
    }
    if (result.sourceURL.absoluteString) {
        responseString = [responseString stringByAppendingString:[NSString stringWithFormat:@"sourceURL: %@\n", result.sourceURL.absoluteString]];
    }
    
    self.searchAPIResponseTextView.text = responseString;
}

@end
