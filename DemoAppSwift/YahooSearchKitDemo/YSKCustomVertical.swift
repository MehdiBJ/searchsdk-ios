//
//  YSKCustomVertical.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKCustomVertical: UIViewController, YSLSearchProtocol, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tumblrPhotos: TumblrPhotos! = TumblrPhotos()
    let TOP_CONTENT_INSET: CGFloat = 10.0
    let BOTTOM_CONTENT_INSET: CGFloat = 40.0
    var tableView: UITableView! = UITableView()
    var sizingCardCell: YSKCustomCardCell! = YSKCustomCardCell(style: UITableViewCellStyle.Default, reuseIdentifier: "sizing")
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Life Cycle functions
    //--------------------------------------------------------------------------------------------------    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        verticalSelectorItem.title = "tumblr"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        self.addConstraints()
        self.setupTumblrClient()
    }
    override func viewWillAppear(animated: Bool) {
        self.startLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: YSLSearchProtocol properties
    //--------------------------------------------------------------------------------------------------
    
    // These are set by searchViewController upon registering
    var searchProgressDelegate: YSLSearchProgressDelegate?
    var consumptionModeDelegate: YSLConsumptionModeDelegate?
    var queryRequest: YSLQueryRequest?
    var verticalSelectorItem: YSLVerticalSelectorItem! = YSLVerticalSelectorItem()
    var mainScrollView: UIScrollView! {
        set {
            // do nothing
        }
        get {
            return tableView
        }
    }
    
    // Protocol-required methods
    
    func startLoading() {
        // Scroll to Top first
        tableView.setContentOffset(CGPointMake(0, -tableView.contentInset.top), animated: true)
        let params: NSMutableDictionary! = NSMutableDictionary()
        params.setObject("photo", forKey: "type")
        params.setObject("text", forKey: "filter")
        let query: String? = queryRequest?.query
        if (query != nil) {
            TMAPIClient.sharedInstance().tagged(query, parameters: params as Dictionary) { (result: AnyObject!, error: NSError!) -> Void in
                if (error == nil) {
                    self.tumblrPhotos = TumblrPhotos(responseDictionaries: result as! [NSDictionary])
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    func stopLoading() {
        self.tumblrPhotos = TumblrPhotos()
        self.tableView.reloadData()
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Setup
    //--------------------------------------------------------------------------------------------------
    
    func setupTumblrClient() {
        TMAPIClient.sharedInstance().OAuthConsumerKey = "uHJxDgqpeoFeg2TJiUU9PYYKV6Q5FnhcaKvrsIEM4PJtkQnnwY"
        TMAPIClient.sharedInstance().defaultCallbackQueue = NSOperationQueue()
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: View Hierarchy setup
    //--------------------------------------------------------------------------------------------------
    
    func addSubviews() {
        tableView = UITableView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.scrollsToTop = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(YSKCustomCardCell.self, forCellReuseIdentifier: "cell")
        
        var inset:UIEdgeInsets = self.tableView.contentInset
        var headerHeight: CGFloat! = 0.0
        headerHeight = self.consumptionModeDelegate?.headerHeight
        inset.top += headerHeight + TOP_CONTENT_INSET
        inset.bottom += BOTTOM_CONTENT_INSET
        self.tableView.contentInset = inset
        self.view.addSubview(tableView)
        
    }
    
    func addConstraints() {
        let viewsDictionary = ["tableView" : tableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UITableViewDelegate methods
    //--------------------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tumblrPhotos.photos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        sizingCardCell.title.text = self.tumblrPhotos.photos[indexPath.row].blogName as String
        sizingCardCell.caption.text = self.tumblrPhotos.photos[indexPath.row].caption as String
        sizingCardCell.tags.text = self.tumblrPhotos.photos[indexPath.row].tagsString as String
        sizingCardCell.setNeedsUpdateConstraints()
        sizingCardCell.updateConstraintsIfNeeded()
        sizingCardCell.setNeedsLayout()
        sizingCardCell.layoutIfNeeded()
        
        let size: CGSize = sizingCardCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return round(size.height + cardTopBottomMargin)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: YSKCustomCardCell! = tableView.dequeueReusableCellWithIdentifier("cell") as! YSKCustomCardCell
        cell.title.text = self.tumblrPhotos.photos[indexPath.row].blogName as String
        cell.caption.text = self.tumblrPhotos.photos[indexPath.row].caption as String
        cell.tags.text = self.tumblrPhotos.photos[indexPath.row].tagsString as String
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let url = NSURL(string: self.tumblrPhotos.photos[indexPath.row].imageUrl)
            let data = NSData(contentsOfURL: url!)
            if (data != nil) {
                let image: UIImage = UIImage(data: data!)!
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.transitionWithView(cell.blogImage, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        cell.blogImage.image = image
                        }, completion: { (Bool) -> Void in
                            //
                    })
                    
                })
            }
        })
        return cell
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIScrollViewDelegate methods
    //--------------------------------------------------------------------------------------------------
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        self.consumptionModeDelegate?.viewController(self, didStartScrollingWithContentOffset: CGPointZero, bottomOffset: CGPointZero)
        self.consumptionModeDelegate?.viewController(self, didFinishScrollingWithContentOffet: CGPointZero, bottomOffset: CGPointZero, velocity: CGPointZero)
        return true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let contentOffset = self.effectiveContentOffsetForScrollView(scrollView, AndTargetOffset: nil)
        let bottomOffset = self.effectiveContentBottomOffsetForScrollView(scrollView, AndTargetOffset: nil)
        
        self.consumptionModeDelegate?.viewController(self, didStartScrollingWithContentOffset: contentOffset, bottomOffset: bottomOffset)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = self.effectiveContentOffsetForScrollView(scrollView, AndTargetOffset: nil)
        let bottomOffset = self.effectiveContentBottomOffsetForScrollView(scrollView, AndTargetOffset: nil)
        
        self.consumptionModeDelegate?.viewController(self, didStartScrollingWithContentOffset: contentOffset, bottomOffset: bottomOffset)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffset = self.effectiveContentOffsetForScrollView(scrollView, AndTargetOffset: targetContentOffset)
        let bottomOffset = self.effectiveContentBottomOffsetForScrollView(scrollView, AndTargetOffset: targetContentOffset)
        
        self.consumptionModeDelegate?.viewController(self, didFinishScrollingWithContentOffet: contentOffset, bottomOffset: bottomOffset, velocity: velocity)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIScrollViewDelegate method helpers
    //--------------------------------------------------------------------------------------------------
    func effectiveContentOffsetForScrollView(scrollView: UIScrollView, AndTargetOffset targetOffset: UnsafeMutablePointer<CGPoint>) -> CGPoint {
        var contentOffset: CGPoint = CGPointZero;
        if (targetOffset != nil) {
            contentOffset = CGPointMake(targetOffset.memory.x, targetOffset.memory.y);
        } else {
            contentOffset = scrollView.contentOffset;
        }
        
        contentOffset = CGPointMake(contentOffset.x, contentOffset.y + scrollView.contentInset.top);
        return contentOffset;
    }
    
    func effectiveContentBottomOffsetForScrollView(scrollView: UIScrollView, AndTargetOffset targetOffset: UnsafeMutablePointer<CGPoint>) -> CGPoint {
        var bottomOffset: CGPoint = CGPointZero
        let effectiveContentSize: CGSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom)
        var contentOffset: CGPoint = CGPointZero
        if (targetOffset != nil) {
            contentOffset = CGPointMake(targetOffset.memory.x, targetOffset.memory.y);
        } else {
            contentOffset = scrollView.contentOffset;
        }
        let effectiveContentOffset: CGPoint = CGPointMake(contentOffset.x, contentOffset.y + scrollView.contentInset.top);
        bottomOffset = CGPointMake(effectiveContentOffset.x, effectiveContentSize.height - (effectiveContentOffset.y+self.view.frame.size.height));
        return bottomOffset;
    }
}