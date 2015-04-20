//
//  YSKAppDelegate.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "YSKAppDelegate.h"
#import <YahooSearchKit/YahooSearchKit.h>
#import "YSKCustomVertical.h"

@interface YSKAppDelegate ()

@end

@implementation YSKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YSLSetting setupWithAppId:@"YourApplicationId"];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}

@end
