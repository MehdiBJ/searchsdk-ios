//
//  YSKCustomVertical.h
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import <UIKit/UIKit.h>
#import <YahooSearchKit/YahooSearchKit.h>

@interface YSKCustomVertical : UIViewController <YSLSearchProtocol>

@property (nonatomic, strong) YSLQueryRequest* queryRequest;

@property (nonatomic, readonly) YSLVerticalSelectorItem *verticalSelectorItem;

@property (nonatomic, weak) id<YSLSearchProgressDelegate> searchProgressDelegate;
@property (nonatomic, weak) id<YSLConsumptionModeDelegate> consumptionModeDelegate;

- (void) startLoading;
- (void) stopLoading;

@end
