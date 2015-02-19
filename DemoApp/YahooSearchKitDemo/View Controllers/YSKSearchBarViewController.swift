//
//  YSKSearchBarViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

enum YSKViewControllerSearchOptions : Int {
    case SearchOptionDefault = 0
    case SearchOptionImages
    case SearchOptionMedia
}

class YSKSearchBarViewController: YSKViewController {

    var selectedSearchOptions:YSKViewControllerSearchOptions!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var searchBarImageButton: UIButton!
    @IBOutlet weak var searchBarMediaButton: UIButton!
    let borderColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0).CGColor

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionDefault
        self.updateButtonsAppearance()
    }

    // MARK: viewDidLoad helper methods

    func updateButtonsAppearance() {
        self.updateButtonAppearance(self.searchBarButton)
        self.updateButtonAppearance(self.searchBarImageButton)
        self.updateButtonAppearance(self.searchBarMediaButton)
    }

    func updateButtonAppearance(button:UIButton) {
        button.layer.borderColor = self.borderColor
        button.layer.borderWidth = 1.0
    }

    // MARK: UI Action Handlers

    @IBAction func previewDefaultSearchBarButtonTapped(sender: UIButton) {
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionDefault
        self.presentSearchViewController();
    }


    @IBAction func defaultSearchOptionsButtonTapped(sender: AnyObject) {
        let searchViewController = YSLSearchViewController()
        searchViewController.delegate = self;
        self.presentViewController(searchViewController, animated: true, completion:nil)
    }

    @IBAction func imageSearchOptionsButtonTapped(sender: UIButton) {
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionImages
        self.presentSearchViewController();
    }

    @IBAction func videoSearchOptionsButtonTapped(sender: UIButton) {
        self.selectedSearchOptions = YSKViewControllerSearchOptions.SearchOptionMedia
        self.presentSearchViewController();
    }

    func presentSearchViewController() {

        var searchViewController:YSLSearchViewController

        if let searchOption = self.selectedSearchOptions {
            switch searchOption {
            case .SearchOptionDefault:
                searchViewController = YSLSearchViewController()
            case .SearchOptionImages:
                searchViewController = YSLSearchViewController()
                searchViewController.setSearchResultTypes([YSLSearchResultTypeImage])

            case .SearchOptionMedia:
                searchViewController = YSLSearchViewController()
                searchViewController.setSearchResultTypes([YSLSearchResultTypeImage, YSLSearchResultTypeVideo])
            }
        } else {
            searchViewController = YSLSearchViewController()
            searchViewController.queryString = ""
        }
        searchViewController.delegate = self;
        self.presentViewController(searchViewController, animated: true, completion:nil)
    }


    // MARK: YSLSearchViewControllerDelegate methods
    func shouldSearchViewControllerLaunchWithSuggestions(viewController: YSLSearchViewController) -> Bool {
        return true;
    }

    override func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        super.searchViewControllerDidTapLeftButton(searchViewController)
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}

