//
//  YSKSearchToLinkViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKSearchToLinkViewController: YSKViewController {

    @IBOutlet weak var searchAPIResponseTextView: UITextView!
    @IBOutlet weak var webSearchButton: UIButton!
    @IBOutlet weak var imageSearchButton: UIButton!
    @IBOutlet weak var videoSearchButton: UIButton!

    override func viewDidLoad() {
        self.title = "Search-to-Link"
        self.updateButtonsAppearance()
    }

    func updateButtonsAppearance() {
        let bordercolor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0)
        self.webSearchButton.layer.borderColor = bordercolor.CGColor
        self.webSearchButton.layer.borderWidth = 1.0
        self.imageSearchButton.layer.borderColor = bordercolor.CGColor
        self.imageSearchButton.layer.borderWidth = 1.0
        self.videoSearchButton.layer.borderColor = bordercolor.CGColor
        self.videoSearchButton.layer.borderWidth = 1.0
    }

    // MARK: UI helper methods

    @IBAction func searchToLinkButtonTapped(sender: UIButton) {

        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchSuggestions = false
        settings.enableSearchToLink = true

        var searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        searchViewController.queryString = ""
        self.presentViewController(searchViewController, animated: true, completion:nil)
    }

    @IBAction func searchImageToLinkButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchToLink = true

        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        searchViewController.setSearchResultTypes([YSLSearchResultTypeImage])
        self.presentViewController(searchViewController, animated: true, completion:nil)
    }

    @IBAction func searchVideoToLinkButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchToLink = true

        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self
        searchViewController.setSearchResultTypes([YSLSearchResultTypeVideo])
        self.presentViewController(searchViewController, animated: true, completion:nil)
    }

    // MARK: YSLSearchViewControllerDelegate methods
    override func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        super.searchViewControllerDidTapLeftButton(searchViewController)
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func searchViewController(searchViewController: YSLSearchViewController!, didSearchToLink result: YSLSearchToLinkResult!) {

        searchViewController.dismissViewControllerAnimated(true, completion: nil)

        var responseString = ""

        if let keywordString = result.queryString {
            responseString += "queryString: \(keywordString)\n"
        }
        if let titleString = result.title {
            responseString += "title: \(titleString)\n"
        }
        if let shortenedURLString = result.shortURL?.absoluteString {
            responseString += "shortURL: \(shortenedURLString)\n"
        }
        if let descriptionString = result.linkDescription {
            responseString += "linkDescription: \(descriptionString)\n"
        }
        if let thumbURLString = result.thumbnailURL?.absoluteString {
            responseString += "thumbnailURL: \(thumbURLString)\n"
        }
        if let urlString = result.sourceURL?.absoluteString {
            responseString += "sourceURL: \(urlString)\n"
        }
        self.searchAPIResponseTextView.text = responseString
    }
}
