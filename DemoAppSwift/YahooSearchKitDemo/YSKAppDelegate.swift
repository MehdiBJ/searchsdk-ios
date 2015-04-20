//
//  YSKAppDelegate.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupYahooSearchSDK()
        self.setupStatusBarAppearance()
        return true
    }

    private func setupYahooSearchSDK() {
        YSLSetting.setupWithAppId("YourApplicationId");
    }

    func setupStatusBarAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

}

