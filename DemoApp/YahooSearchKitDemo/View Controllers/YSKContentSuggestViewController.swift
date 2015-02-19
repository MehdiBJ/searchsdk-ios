//
//  YSKContentSuggestViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit;


class YSKContentSuggestViewController: YSKViewController {

    @IBOutlet weak var webSearchButton: UIButton!
    @IBOutlet weak var imageSearchButton: UIButton!
    let borderColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).CGColor

    override func viewDidLoad() {
        self.updateButtonsAppearance()
    }
    
    func updateButtonsAppearance() {
        self.webSearchButton.layer.borderColor = self.borderColor
        self.imageSearchButton.layer.borderColor = self.borderColor
        self.webSearchButton.layer.borderWidth = 1.0
        self.imageSearchButton.layer.borderWidth = 1.0
    }

    @IBAction func webSearchButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchSuggestions = false

        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self;
        searchViewController.queryString = "Augmented Reality"

        UIApplication.sharedApplication().statusBarStyle = .Default
        self.presentViewController(searchViewController, animated: true, completion:nil)

    }

    @IBAction func imageSearchButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchSuggestions = false

        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        searchViewController.setSearchResultTypes([YSLSearchResultTypeImage])
        searchViewController.queryString = "cats"

        self.presentViewController(searchViewController, animated: true, completion:nil)

    }

    // MARK: YSLSearchViewControllerDelegate methods

    override func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        super.searchViewControllerDidTapLeftButton(searchViewController)
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
