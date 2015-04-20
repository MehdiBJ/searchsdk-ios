//
//  YSKCustomHeader.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKCustomHeader.h"

@interface YSKCustomHeader () <UITextFieldDelegate>

// MARK: UI elements
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *border;

// MARK: UIColor for custom themes
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *leftButtonColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *headerBackgroundColor;

@property (nonatomic) NSUInteger headerMode;
@property (nonatomic, strong) NSString *originalQuery;

@property (nonatomic, readwrite) CGFloat maximumHeight;
@property (nonatomic, readwrite) CGFloat minimumHeight;

@end

@implementation YSKCustomHeader

#pragma mark - Set Header Mode

- (void)setHeaderMode:(NSUInteger)newValue {
    if (_headerMode != newValue) {
        if (newValue == YSCHeaderViewNormalMode) {
            [self toggleUIToNormalMode];
        } else if (newValue == YSCHeaderViewActiveEditMode) {
            [self toggleUIToEditMode];
        }
        
        if (newValue != YSCHeaderViewActiveEditMode) {
            [self.textField resignFirstResponder];
        }
        _headerMode = newValue;
    }
}

#pragma mark - YSLHeaderProtocol

- (void)setQueryString:(NSString*)newValue {
    _queryString = newValue;
    self.textField.text = newValue;
    
}

- (void)setPlaceHolderString:(NSString*)newValue {
    _placeHolderString = newValue;
    self.textField.placeholder = newValue;
    
}

- (void)dismissKeyboard {
    if (self.headerMode == YSCHeaderViewActiveEditMode) {
        [self.textField resignFirstResponder];
        self.headerMode = YSCHeaderViewPassiveEditMode;
    }
}

- (void)setEditing:(BOOL)editing {
    NSUInteger mode = YSCHeaderViewNormalMode;
    if (editing) {
        mode = YSCHeaderViewActiveEditMode;
    }
    
    self.headerMode = mode;
    if (editing) {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.textColor = [UIColor blackColor];
        self.placeholderColor = [UIColor grayColor];
        self.leftButtonColor = [UIColor blackColor];
        self.borderColor = [UIColor blackColor];
        self.cancelButtonColor = [UIColor blackColor];
        self.headerBackgroundColor = [UIColor whiteColor];
        
        [self initialInitialization];
    }
    return self;
}

- (void)initialInitialization {
    self.maximumHeight = 66.0f;
    self.minimumHeight = 20.0f;
    
    /* Setup view Hierarchy */
    [self setupViews];
    
    /* Start in Normal Mode */
    [self toggleUIToNormalMode];
    
    /* Add constraints for content View */
    [self.contentView addConstraints:[self contentViewConstraints]];
}

#pragma mark - View Hierarchy setup

- (void)setupViews {

    // Setup content view
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.contentView];
    
    // Setup left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f);
    [self.leftButton setImage:[[UIImage imageNamed:@"LeftArrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    self.leftButton.tintColor = self.leftButtonColor;
    [self.leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.leftButton];
    
    // Setup text field
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [self.textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.textField.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    self.textField.delegate = self;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search"
                                                                           attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
    self.textField.tintColor = self.textColor;
    self.textField.textColor = self.textColor;
    [self.contentView addSubview:self.textField];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"ClearButton"] forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    clearButton.alpha = 0.6f;
    [clearButton addTarget:self action:@selector(clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = clearButton;
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    
    // Setup cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    self.cancelButton.tintColor = self.cancelButtonColor;
    [self.cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.cancelButton];
    
    // Border
    self.border = [UIView new];
    self.border.backgroundColor = self.borderColor;
    [self.border setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.border];
    
    // Constraints
    NSDictionary *viewsDictionary = @{@"contentView": self.contentView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[contentView]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - Constraints

- (NSMutableArray*)contentViewConstraints {

    NSMutableArray *contentViewConstraints = [NSMutableArray new];
    NSDictionary *viewsDictionary = @{@"contentView": self.contentView,
                        @"leftButton": self.leftButton,
                        @"textField": self.textField,
                        @"cancelButton": self.cancelButton,
                        @"border": self.border};
    
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField(20)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textField(>=30)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftButton(44)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftButton(44)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancelButton(50)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(20)]" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[border]|" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[border(1)]|" options:0 metrics:nil views:viewsDictionary]];
    [contentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [contentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [contentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [contentViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[leftButton]-[textField]-[cancelButton]-|" options:0 metrics:nil views:viewsDictionary]];
    
    return contentViewConstraints;
}

#pragma mark - Utilities

- (void)toggleUIToNormalMode {
    self.cancelButton.enabled = NO;
    [UIView animateWithDuration:0.1f animations:^{
        self.cancelButton.alpha = 0.0f;
    }];
}

- (void)toggleUIToEditMode {
    self.cancelButton.enabled = YES;
    [UIView animateWithDuration:0.1f animations:^{
        self.cancelButton.alpha = 1.0f;
    }];
}

#pragma mark - UIButton Target actions

- (void)leftButtonTapped:(UIButton*)sender {
    [self.delegate leftButtonTappedInHeaderView:self];
}

- (void)clearButtonTapped:(UIButton*)sender {
    self.textField.text = @"";
    [self.delegate header:self didChangeQueryString:@""];
}

- (void)cancelButtonTapped:(UIButton*)sender {
    self.headerMode = YSCHeaderViewNormalMode;
    
    NSString *currentQuery = self.textField.text;
    self.textField.text = self.originalQuery;
    self.originalQuery = nil;
    [self toggleUIToNormalMode];
    
    [self.delegate header:self didCancelEditingQueryString:currentQuery];
    [self.delegate cancelButtonTappedInHeaderView:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField*)textField {
    [self.delegate header:self didChangeQueryString:@""];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    if (self.headerMode == YSCHeaderViewNormalMode) {
        self.originalQuery = self.textField.text;
        [self.delegate header:self willBeginEditingQueryString:self.textField.text];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    if (self.headerMode == YSCHeaderViewNormalMode) {
        [self.delegate header:self didBeginEditingQueryString:self.textField.text];
    }
    self.headerMode = YSCHeaderViewActiveEditMode;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newQuery = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.delegate header:self didChangeQueryString:newQuery];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = NO;
    self.headerMode = YSCHeaderViewNormalMode;
    [self.delegate header:self didEndEditingQueryString:self.textField.text];
    shouldReturn = YES;
    return shouldReturn;
}

#pragma mark - Custom initialization

- (instancetype)initWithTheme:(NSUInteger)theme {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        switch (theme) {
            case YSCHeaderViewThemeDark:
                self.headerBackgroundColor = [UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:27.0f/255.0f alpha:1.0f];
                self.textColor = [UIColor whiteColor];
                self.borderColor = [UIColor clearColor];
                self.leftButtonColor = [UIColor whiteColor];
                self.cancelButtonColor = [UIColor whiteColor];
                self.placeholderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                break;
            case YSCHeaderViewThemeWhite:
                self.headerBackgroundColor = [UIColor whiteColor];
                self.leftButtonColor = [UIColor colorWithRed:65.0f/255.0f green:0.0f blue:144.0f/255.0f alpha:1.0f];
                self.textColor = [UIColor blackColor];
                self.borderColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
                self.cancelButtonColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
                self.placeholderColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
                break;
            case YSCHeaderViewThemeTransparent:
                self.headerBackgroundColor = [UIColor colorWithRed:111.0f/255.0f green:139.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
                self.leftButtonColor = [UIColor whiteColor];
                self.textColor = [UIColor whiteColor];
                self.borderColor = [UIColor clearColor];
                self.cancelButtonColor = [UIColor whiteColor];
                self.placeholderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                break;
            case YSCHeaderViewThemeTumblr:
                self.headerBackgroundColor = [UIColor colorWithRed:43.0f/255.0f green:63.0f/255.0f blue:83.0f/255.0f alpha:1.0f];
                self.leftButtonColor = [UIColor whiteColor];
                self.textColor = [UIColor whiteColor];
                self.borderColor = [UIColor clearColor];
                self.cancelButtonColor = [UIColor whiteColor];
                self.placeholderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                break;
        }
        self.backgroundColor = self.headerBackgroundColor;
        
        [self initialInitialization];
    }
    return self;
}

@end
