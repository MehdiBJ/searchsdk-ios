//
//  YSLSearchViewController+customization.h
//  YahooSearchLibrary
//
//  Copyright (c) 2015 Yahoo! Inc. All rights reserved.
//

#import "YSLSearchViewController.h"

@protocol YSLVerticalSelector;
@protocol YSLHeaderProtocol;
@protocol YSLSearchToLinkFooterProtocol;

@interface YSLSearchViewController (customization)

/**
 * This is the header view to be presented in the search view controller.
 * 
 * @discussion A default header will be used if this property is not set. If a header is not required, it has to be explicitly set to nil.
 */
@property (nonatomic, strong) UIView<YSLHeaderProtocol> *headerView;

/**
 * This is the footer view to be presented in the search view controller.
 *
 * @discussion A default footer will be used if this property is not set. If a footer is not required, it has to be explicitly set to nil.
 */
@property (nonatomic, strong) UIView<YSLVerticalSelector> *footerView;

/**
 This is the landing view to be presented before the user does a search.
 *
 * @discussion The view of the landing page view controller will be shown as soon as the search screen is shown.
 * This landing page view controller's view will be removed from the hierarchy as soon as the user submits a query.
 */
@property (nonatomic, strong) UIViewController* landingPageViewController;

@property (nonatomic, strong) UIView<YSLSearchToLinkFooterProtocol> *shareFooterView;

/**
 This property indicates whether to show or hide the landing page. 
 
 @discussion Setting this property does not guarantee the landing page is shown immediately, the view will be shown only when the search view controller is loaded
 */
@property (nonatomic, assign, getter = isLandingPageHidden) BOOL hideLandingPage;


@end