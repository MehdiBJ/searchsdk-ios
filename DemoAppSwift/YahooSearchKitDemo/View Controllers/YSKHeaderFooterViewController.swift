//
//  YSKSearchBarViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKHeaderFooterViewController : UIViewController, YSLSearchViewControllerDelegate {
    
    var selectedSearchOptions:YSKViewControllerSearchOptions!
    let borderColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).CGColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionDefault
    }
    
    // MARK: UI Action Handlers
    @IBAction func whiteThemeButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        
        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        let headerView: YSKCustomHeader! = YSKCustomHeader(theme: YSCHeaderViewTheme.White)
        searchViewController.headerView = headerView
        let footerView: YSKCustomFooter! = YSKCustomFooter(theme: YSCFooterViewTheme.White)
        searchViewController.footerView = footerView
        UIApplication.sharedApplication().statusBarStyle = .Default
        searchViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(searchViewController, animated: true, completion:nil)
    }
    
    @IBAction func darkThemeButtonTapped(sender: AnyObject) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        
        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        let headerView: YSKCustomHeader! = YSKCustomHeader(theme: YSCHeaderViewTheme.Dark)
        searchViewController.headerView = headerView
        let footerView: YSKCustomFooter! = YSKCustomFooter(theme: YSCFooterViewTheme.Dark)
        searchViewController.footerView = footerView
        searchViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(searchViewController, animated: true, completion: nil)
    }
    
    @IBAction func transparentThemeTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableTransparency = true
        let searchViewController = YSLSearchViewController(settings: settings)
        
        // Screenshot
        /*
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.mainScreen().scale)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        var snapshot:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        */
        
        let snapshot: UIImage! = UIImage(named: "BGimage.png")
        
        
        // Setting it to landing page
        let landingPage: YSKLandingPageViewController! = YSKLandingPageViewController()
        landingPage.backgroundImage = snapshot
        searchViewController.landingPageViewController = landingPage
        searchViewController.hideLandingPage = false
        
        searchViewController.delegate = self
        let headerView: YSKCustomHeader! = YSKCustomHeader(theme: YSCHeaderViewTheme.Transparent)
        searchViewController.headerView = headerView
        let footerView: YSKCustomFooter! = YSKCustomFooter(theme: YSCFooterViewTheme.Transparent)
        searchViewController.footerView = footerView
        searchViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(searchViewController, animated: true, completion:nil)
    }
    
    // MARK: YSLSearchViewControllerDelegate methods
    func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func searchViewController(searchViewController: YSLSearchViewController!, actionForQueryString queryString: String!) -> YSLQueryAction {
        return YSLQueryAction.ShowSuggestions
    }
    
}

