//
//  YSKSettingsViewController.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKSettingsViewController.h"
#import <YahooSearchKit/YahooSearchKit.h>

@interface YSKSettingsViewController () <YSLSearchViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *webSearchFilterButton;
@property (nonatomic, weak) IBOutlet UIButton *imageSearchFilterButton;
@property (nonatomic, weak) IBOutlet UIButton *videoSearchFilterButton;
@property (nonatomic, weak) IBOutlet UIView *filterButtonsContainerView;
@property (nonatomic, weak) IBOutlet UIButton *previewButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *contentSuggestField;

@property (nonatomic) BOOL searchAssistOptionOn;
@property (nonatomic, strong) NSMutableArray *searchResultTypes;
@property (nonatomic) BOOL webSearchFilterSelected;
@property (nonatomic) BOOL imageSearchFilterSelected;
@property (nonatomic) BOOL videoSearchFilterSelected;
@property (nonatomic, strong) NSString *contentSuggestText;
@property (nonatomic, strong) YSLSearchViewControllerSettings *settings;
@property (nonatomic, strong) UIColor *filterButtonsDefaultColor;

@end

@implementation YSKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialInitialization];
    [self updateButtonsAppearance];
}

#pragma mark - viewDidLoad helper methods

- (void)initialInitialization {
    self.searchResultTypes = [NSMutableArray new];
    self.settings = [YSLSearchViewControllerSettings new];
    self.searchAssistOptionOn = self.settings.enableSearchSuggestions;
    self.webSearchFilterSelected = NO;
    self.imageSearchFilterSelected = NO;
    self.videoSearchFilterSelected = NO;
    self.contentSuggestText = @"";
    self.filterButtonsDefaultColor = [UIColor colorWithRed:217/255.0f green:216/255.0f blue:223/255.0f alpha:1.0f];
    self.contentSuggestField.delegate = self;
}

- (void)updateButtonsAppearance {
    UIColor *borderColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
    self.previewButton.layer.borderColor = borderColor.CGColor;
    self.previewButton.layer.borderWidth = 1.0f;
}

#pragma mark - Action Outlets

- (IBAction)previewButtonTapped:(UIButton*)sender {
    YSLSearchViewControllerSettings *settings = [YSLSearchViewControllerSettings new];
    settings.enableSearchSuggestions = self.searchAssistOptionOn;
    // settings missing search history
    
    YSLSearchViewController *searchViewController = [[YSLSearchViewController alloc] initWithSettings:settings];
    searchViewController.delegate = self;
    
    [searchViewController setSearchResultTypes:self.searchResultTypes];
    searchViewController.queryString = self.contentSuggestText;
    [self presentViewController:searchViewController animated:NO completion:nil];
    
}

- (IBAction)searchAssistOptionsControlValueChanged:(UISwitch*)sender {
    self.searchAssistOptionOn = sender.on;
}

- (IBAction)webSearchResultsFilterButtonTapped:(UIButton*)sender {
    self.webSearchFilterSelected = !self.webSearchFilterSelected;
    self.webSearchFilterButton.backgroundColor = self.webSearchFilterSelected ? [UIColor lightGrayColor] : self.filterButtonsDefaultColor;
    [self updateSearchResultTypeSelectedState:YSLSearchResultTypeWeb isSelected:self.webSearchFilterSelected];
}

- (IBAction)imageSearchResultsFilterButtonTapped:(UIButton*)sender {
    self.imageSearchFilterSelected = !self.imageSearchFilterSelected;
    self.imageSearchFilterButton.backgroundColor = self.imageSearchFilterSelected ? [UIColor lightGrayColor] : self.filterButtonsDefaultColor;
    [self updateSearchResultTypeSelectedState:YSLSearchResultTypeImage isSelected:self.imageSearchFilterSelected];
}

- (IBAction)videoSearchResultsFilterButtonTapped:(UIButton*)sender {
    self.videoSearchFilterSelected = !self.videoSearchFilterSelected;
    self.videoSearchFilterButton.backgroundColor = self.videoSearchFilterSelected ? [UIColor lightGrayColor] : self.filterButtonsDefaultColor;
    [self updateSearchResultTypeSelectedState:YSLSearchResultTypeVideo isSelected:self.videoSearchFilterSelected];
}

#pragma mark - UITextFieldDelegate methods

- (IBAction)contentSuggestTextFieldEditingChanged:(UITextField*)sender {
    self.contentSuggestText = sender.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.contentSuggestField) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - SearchResultsFilterButtonTapped helper methods

- (void)updateSearchResultTypeSelectedState:(NSString*)searchResultType isSelected:(BOOL)isSelected {
    if (isSelected) {
        [self includeSearchResultType:searchResultType];
    } else {
        [self excludeSearchResultType:searchResultType];
    }
}

- (void)includeSearchResultType:(NSString*)searchResultType {
    if (![self.searchResultTypes containsObject:searchResultType]) {
        [self.searchResultTypes addObject:searchResultType];
    }
}

- (void)excludeSearchResultType:(NSString*)searchResultType {
    if ([self.searchResultTypes containsObject:searchResultType]) {
        [self.searchResultTypes removeObject:searchResultType];
    }
}

#pragma mark -  YSLSearchViewControllerDelegate methods

- (void)searchViewControllerDidTapLeftButton:(YSLSearchViewController*)searchViewController {
    [super searchViewControllerDidTapLeftButton:searchViewController];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
