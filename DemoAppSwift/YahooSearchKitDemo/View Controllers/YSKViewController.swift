//
//  YSKViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKViewController: UIViewController, YSLSearchViewControllerDelegate {

    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        UIApplication.sharedApplication().statusBarStyle = .Default
        super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }

    // MARK: YSLSearchViewControllerDelegate methods
    func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func searchViewController(searchViewController: YSLSearchViewController!, actionForQueryString queryString: String!) -> YSLQueryAction {
        return YSLQueryAction.Search
    }
}
