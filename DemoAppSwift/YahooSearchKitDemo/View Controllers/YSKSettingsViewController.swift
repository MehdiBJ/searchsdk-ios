//
//  YSKSettingsViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKSettingsViewController: YSKViewController {

    @IBOutlet weak var webSearchFilterButton: UIButton!
    @IBOutlet weak var imageSearchFilterButton: UIButton!
    @IBOutlet weak var videoSearchFilterButton: UIButton!
    @IBOutlet weak var filterButtonsContainerView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var searchAssistOptionOn:Bool!
    var searchResultTypes:[String]!
    var webSearchFilterSelected:Bool!
    var imageSearchFilterSelected:Bool!
    var videoSearchFilterSelected:Bool!
    var contentSuggestText:String!
    var settings:YSLSearchViewControllerSettings!
    let filterButtonsDefaultColor = UIColor(red: 217/255, green: 216/255, blue: 223/255, alpha: 1.0)


    override func viewDidLoad() {
        super.viewDidLoad()
        self.intializePropertiesDefaultValues()
        self.updateButtonsAppearance()
    }

    // MARK: viewDidLoad helper methods

    func intializePropertiesDefaultValues() {
        self.searchResultTypes = [String]()
        self.settings = YSLSearchViewControllerSettings()
        self.searchAssistOptionOn = self.settings.enableSearchSuggestions
        self.webSearchFilterSelected = false
        self.imageSearchFilterSelected = false
        self.videoSearchFilterSelected = false
        self.contentSuggestText = ""
    }


    func updateButtonsAppearance() {
        let bordercolor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0)
        self.previewButton.layer.borderColor = bordercolor.CGColor
        self.previewButton.layer.borderWidth = 1.0
    }

    // MARK: Action Outlets
    @IBAction func previewButtonTapped(sender: UIButton) {
        let settings:YSLSearchViewControllerSettings = YSLSearchViewControllerSettings()
        settings.enableSearchSuggestions = self.searchAssistOptionOn
        // settings missing search history

        let searchViewController = YSLSearchViewController(settings: settings)
        searchViewController.delegate = self

        searchViewController.setSearchResultTypes(self.searchResultTypes)
        searchViewController.queryString = self.contentSuggestText
        self.presentViewController(searchViewController, animated: true, completion:nil)

    }

    @IBAction func searchAssistOptionsControlValueChanged(sender: UISwitch) {
        self.searchAssistOptionOn = sender.on
    }

    @IBAction func webSearchResultsFilterButtonTapped(sender: UIButton) {
        self.webSearchFilterSelected = !webSearchFilterSelected
        self.webSearchFilterButton.backgroundColor = self.webSearchFilterSelected! ? UIColor.lightGrayColor():self.self.filterButtonsDefaultColor
        self.updateSearchResultTypeSelectedState(YSLSearchResultTypeWeb, isSelected: self.webSearchFilterSelected)

    }

    @IBAction func imageSearchResultsFilterButtonTapped(sender: UIButton) {
        self.imageSearchFilterSelected = !imageSearchFilterSelected
        self.imageSearchFilterButton.backgroundColor = self.imageSearchFilterSelected! ? UIColor.lightGrayColor():self.filterButtonsDefaultColor
        self.updateSearchResultTypeSelectedState(YSLSearchResultTypeImage, isSelected: self.imageSearchFilterSelected)
    }

    @IBAction func videoSearchResultsFilterButtonTapped(sender: UIButton) {
        self.videoSearchFilterSelected = !videoSearchFilterSelected
        self.videoSearchFilterButton.backgroundColor = self.videoSearchFilterSelected! ? UIColor.lightGrayColor():self.filterButtonsDefaultColor
        self.updateSearchResultTypeSelectedState(YSLSearchResultTypeVideo, isSelected: self.videoSearchFilterSelected)
    }

    @IBAction func contentSuggestTextFieldEditingChanged(sender: UITextField) {
        self.contentSuggestText = sender.text
    }

    // MARK: SearchResultsFilterButtonTapped helper methods
    func updateSearchResultTypeSelectedState(searchResultType:String, isSelected:Bool) {
        if (isSelected) {
            self.includeSearchResultType(searchResultType)
        } else {
            self.excludeSearchResultType(searchResultType)
        }
    }

    func includeSearchResultType(searchResultType:String) {
        if (self.searchResultTypes.indexOf(searchResultType) == nil) {
            self.searchResultTypes.append(searchResultType)
        }
    }

    func excludeSearchResultType(searchResultType:String) {
        if let index = self.searchResultTypes.indexOf(searchResultType) {
            self.searchResultTypes.removeAtIndex(index)
        }
    }

    // MARK: YSLSearchViewControllerDelegate methods
    override func searchViewControllerDidTapLeftButton(searchViewController: YSLSearchViewController!) {
        super.searchViewControllerDidTapLeftButton(searchViewController)
        searchViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
