//
//  YSKVerticalViewController.swift
//  YahooSearchKitDemo
//
//  Created by Benjamin Lin on 4/13/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

import UIKit

class YSKVerticalViewController : UIViewController, YSLSearchViewControllerDelegate {
    
    var selectedSearchOptions:YSKViewControllerSearchOptions!
    let borderColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).CGColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionDefault
    }
    
    // MARK: UI Action Handlers
    @IBAction func webImageVideoTumblrButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableTransparency = true
        let searchViewController = YSLSearchViewController(settings: settings)
        
        let landingPage: YSKLandingPageViewController! = YSKLandingPageViewController()
        landingPage.view.backgroundColor = UIColor(red: CGFloat(54.0/255.0), green: CGFloat(70.0/255.0), blue: CGFloat(93.0/255.0), alpha: 1.0)
        searchViewController.landingPageViewController = landingPage
        searchViewController.hideLandingPage = false
        
        var tumblrVertical: YSKCustomVertical = YSKCustomVertical()
        YSLSetting.sharedSetting().registerSearchResultClass(YSKCustomVertical.self, forType: "tumblr")
        
        let array: NSMutableArray! = NSMutableArray()
        array.addObject(YSLSearchResultTypeWeb)
        array.addObject(YSLSearchResultTypeImage)
        array.addObject(YSLSearchResultTypeVideo)
        array.addObject("tumblr")
        searchViewController.setSearchResultTypes(array as Array)
        searchViewController.queryString = "Yahoo"
        
        searchViewController.delegate = self
        let headerView: YSKCustomHeader! = YSKCustomHeader(theme: YSCHeaderViewTheme.Tumblr)
        searchViewController.headerView = headerView
        let footerView: YSKCustomFooter! = YSKCustomFooter(theme: YSCFooterViewTheme.Tumblr)
        searchViewController.footerView = footerView
        searchViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(searchViewController, animated: true, completion:nil)
    }
    
    @IBAction func webTumblrButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableTransparency = true
        let searchViewController = YSLSearchViewController(settings: settings)
        
        let landingPage: YSKLandingPageViewController! = YSKLandingPageViewController()
        landingPage.view.backgroundColor = UIColor(red: CGFloat(54.0/255.0), green: CGFloat(70.0/255.0), blue: CGFloat(93.0/255.0), alpha: 1.0)
        searchViewController.landingPageViewController = landingPage
        searchViewController.hideLandingPage = false
        
        var tumblrVertical: YSKCustomVertical = YSKCustomVertical()
        YSLSetting.sharedSetting().registerSearchResultClass(YSKCustomVertical.self, forType: "tumblr")
        
        let array: NSMutableArray! = NSMutableArray()
        array.addObject("tumblr")
        array.addObject(YSLSearchResultTypeWeb)
        searchViewController.setSearchResultTypes(array as Array)
        searchViewController.queryString = "Yahoo"
        
        searchViewController.delegate = self
        let headerView: YSKCustomHeader! = YSKCustomHeader(theme: YSCHeaderViewTheme.Tumblr)
        searchViewController.headerView = headerView
        let footerView: YSKCustomFooter! = YSKCustomFooter(theme: YSCFooterViewTheme.Tumblr)
        searchViewController.footerView = footerView
        searchViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(searchViewController, animated: true, completion:nil)
    }
    
    // MARK: YSLSearchViewControllerDelegate methods
    
    func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        YSLSetting.sharedSetting().deregisterSearchResultType("tumblr")
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func searchViewController(searchViewController: YSLSearchViewController!, actionForQueryString queryString: String!) -> YSLQueryAction {
        return YSLQueryAction.Default
    }
    
}
