//
//  YSKCustomFooter.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

/* Optional - enum types for different types of themes */
enum YSCFooterViewTheme: Int {
    case White = 0
    case Dark
    case Transparent
    case Tumblr
}

class YSKCustomFooter: UIView, YSLVerticalSelector {
    
    /*--------------------------------------------------------------------------------------------------
    -----------------------------------------MARK: REQUIRED---------------------------------------------
    --------------------------------------------------------------------------------------------------*/
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UI elements
    //--------------------------------------------------------------------------------------------------
    private var verticalSelectorItemViews:NSMutableArray! = []
    private var border:UIView!
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIColor for custom themes
    //--------------------------------------------------------------------------------------------------
    private var activeBackgroundColor: UIColor! = UIColor.blackColor()
    private var inactiveBackgroundColor: UIColor! = UIColor.grayColor()
    private var activeItemColor: UIColor! = UIColor.whiteColor()
    private var inactiveItemColor: UIColor! = UIColor.whiteColor()
    private var borderColor: UIColor! = UIColor.blackColor()
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Internal Implementation variables
    //--------------------------------------------------------------------------------------------------
    var verticalSelectorDelegate:YSLVerticalSelectorDelegate!
    private var enableIcon: Bool = false
    private var _selectedItemIndex: UInt = 0
    private var _items:NSArray!
    
    //--------------------------------------------------------------------------------------------------
    // MARK: YSLVerticalSelector Protocol
    //--------------------------------------------------------------------------------------------------
    let maximumHeight:CGFloat = 45.0
    
    var items:[AnyObject]! {
        set {
            _items = newValue
            for verticalSelectorItemView in verticalSelectorItemViews {
                (verticalSelectorItemView as! UIView).removeFromSuperview()
            }
            
            _items.enumerateObjectsUsingBlock({anItem, index, stop in
                let itemView: UIView! = self.verticalSelectorItemView(index, item: anItem as! YSLVerticalSelectorItem)
                self.addSubview(itemView)
            })
            
            selectedItemIndex = 0
            
            self.setNeedsLayout()
        }
        get {
            return _items as Array
        }
    }
    
    var selectedItemIndex:UInt {
        set {
            let oldTabView: UIView! = (verticalSelectorItemViews[Int(_selectedItemIndex)] as! UIView)
            let newTabView: UIView! = (verticalSelectorItemViews[Int(newValue)] as! UIView)
            let oldChildViews : NSArray! = (oldTabView.subviews[0] ).subviews
            oldChildViews.enumerateObjectsUsingBlock({childView, index, stop in
                (childView as! UIView).tintColor = self.inactiveItemColor
            })
            let newChildViews : NSArray! = (newTabView.subviews[0] ).subviews
            newChildViews.enumerateObjectsUsingBlock({childView, index, stop in
                (childView as! UIView).tintColor = self.activeItemColor
            })
            oldTabView.backgroundColor = inactiveBackgroundColor
            newTabView.backgroundColor = activeBackgroundColor
            _selectedItemIndex = newValue
        }
        get {
            return _selectedItemIndex
        }
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Initialization
    //--------------------------------------------------------------------------------------------------
    
    init() {
        // Note: No need to provide frame, constraints will position the footer based on maximumHeight accordingly
        super.init(frame: CGRectZero)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: View hierarchy layout setup
    //--------------------------------------------------------------------------------------------------
    
    override func layoutSubviews() {
        // Border
        border = UIView()
        border.backgroundColor = borderColor
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        var itemViews: NSArray! = verticalSelectorItemViews
        var widthForEachView: CGFloat! = 0.0
        var selectorItemsCount: Int = self.items.count
        if (selectorItemsCount > 0) {
            widthForEachView = self.frame.size.width/CGFloat(selectorItemsCount)
        }
        verticalSelectorItemViews.enumerateObjectsUsingBlock({aView, index, stop in
            var frame :CGRect = CGRectZero
            frame.size = CGSizeMake(widthForEachView, self.frame.size.height)
            frame.origin.x = widthForEachView * CGFloat(index)
            (aView as! UIView).frame = frame
        })
        
        let viewsDictionary = ["border":border]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[border]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[border(1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
        
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Individiual Selector View Setup
    //--------------------------------------------------------------------------------------------------
    
    func verticalSelectorItemView(index: Int, item: YSLVerticalSelectorItem) -> UIView {
        var tabView: UIView! = nil
        if (index < self.verticalSelectorItemViews.count) {
            tabView = verticalSelectorItemViews[index] as! UIView
        } else {
            tabView = UIView()
            tabView.backgroundColor = inactiveBackgroundColor
            tabView.autoresizingMask =  [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            var contentView:UIView! = UIView()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            // Icon
            var verticalSelectorIcon:UIImageView! = UIImageView(image: UIImage(named: "Web.png"))
            if (enableIcon) {
                if (item.searchResultType == YSLSearchResultTypeWeb) {
                    verticalSelectorIcon = UIImageView(image: UIImage(named: "Web.png"))
                } else if (item.searchResultType == YSLSearchResultTypeImage) {
                    verticalSelectorIcon = UIImageView(image: UIImage(named: "Image.png"))
                } else if (item.searchResultType == YSLSearchResultTypeVideo) {
                    verticalSelectorIcon = UIImageView(image: UIImage(named: "Video.png"))
                }
                verticalSelectorIcon.image = verticalSelectorIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                verticalSelectorIcon.translatesAutoresizingMaskIntoConstraints = false
                verticalSelectorIcon.tintColor = inactiveItemColor
            }
            
            // Title Button
            var verticalSelector:UIButton! = UIButton(type: UIButtonType.System)
            verticalSelector.translatesAutoresizingMaskIntoConstraints = false
            verticalSelector.tag = index
            verticalSelector.exclusiveTouch = true
            verticalSelector.setTitle(item.title , forState: .Normal)
            verticalSelector.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            verticalSelector.titleLabel?.textAlignment = NSTextAlignment.Left
            verticalSelector.tintColor = inactiveItemColor
            verticalSelector.addTarget(self, action: "verticalSelectorItemClicked:", forControlEvents: .TouchDown)
            
            // View Hierarchy
            tabView.addSubview(contentView)
            contentView.addSubview(verticalSelector)
            
            if (enableIcon) {
                contentView.addSubview(verticalSelectorIcon)
            }
            
            // Constraints
            let viewsDictionary = ["contentView":contentView, "tabView":tabView,"icon":verticalSelectorIcon, "label":verticalSelector]
            
            
            // Constrains for the image icon
            if (enableIcon) {
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[icon(20)]-3-[label]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[icon(20)]", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
                contentView.addConstraint(NSLayoutConstraint(item: verticalSelectorIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
            } else {
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
            }
            
            
            // Constrains for the button
            contentView.addConstraint(NSLayoutConstraint(item: verticalSelector, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
            
            // Constraints for the contentView
            tabView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: tabView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
            tabView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: tabView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
            tabView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: tabView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0))
            
            verticalSelectorItemViews.addObject(tabView)
        }
        return tabView
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIButton Target Action
    //--------------------------------------------------------------------------------------------------
    
    func verticalSelectorItemClicked(sender:UIButton!) {
        selectedItemIndex = UInt(sender.tag)
        self.verticalSelectorDelegate.verticalSelector(self, selectItemAtIndex: UInt(sender.tag))
    }
    
    /*--------------------------------------------------------------------------------------------------
    -----------------------------------------MARK: OPTIONAL---------------------------------------------
    --------------------------------------------------------------------------------------------------*/
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Custom initialization
    //--------------------------------------------------------------------------------------------------
    
    init(theme:YSCFooterViewTheme) {
        super.init(frame: CGRectZero)
        /* Setup Theme */
        switch (theme) {
        case .Dark:
            activeBackgroundColor = UIColor(red: CGFloat(71.0/255.0), green: CGFloat(71.0/255.0), blue: CGFloat(72.0/255.0), alpha: 1.0)
            activeItemColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            inactiveBackgroundColor = UIColor(red: CGFloat(25.0/255.0), green: CGFloat(25.0/255.0), blue: CGFloat(27.0/255.0), alpha: 1.0)
            inactiveItemColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
            borderColor = UIColor.clearColor()
            enableIcon = true
            break
        case .White:
            activeBackgroundColor = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(241.0/255.0), blue: CGFloat(241.0/255.0), alpha: 1.0)
            activeItemColor = UIColor(red: CGFloat(64.0/255.0), green: 0.0, blue: CGFloat(144.0/255.0), alpha: 1.0)
            inactiveBackgroundColor = UIColor.whiteColor()
            inactiveItemColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
            borderColor = UIColor(red: CGFloat(213.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(213.0/255.0), alpha: 1.0)
            break
        case .Transparent:
            activeBackgroundColor = UIColor(red: CGFloat(94.0/255.0), green: CGFloat(118.0/255.0), blue: CGFloat(162.0/255.0), alpha: 1.0)
            activeItemColor = UIColor.whiteColor()
            inactiveBackgroundColor = UIColor(red: CGFloat(111.0/255.0), green: CGFloat(139.0/255.0), blue: CGFloat(191.0/255.0), alpha: 1.0)
            inactiveItemColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            borderColor = UIColor.clearColor()
            enableIcon = true
            break
        case .Tumblr:
            activeBackgroundColor = UIColor(red: CGFloat(58.0/255.0), green: CGFloat(75.0/255.0), blue: CGFloat(95.0/255.0), alpha: 1.0)
            activeItemColor = UIColor.whiteColor()
            inactiveBackgroundColor = UIColor(red: CGFloat(58.0/255.0), green: CGFloat(75.0/255.0), blue: CGFloat(95.0/255.0), alpha: 1.0)
            inactiveItemColor = UIColor(red: CGFloat(135.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(158.0/255.0), alpha: 1.0)
            borderColor = UIColor.clearColor()
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
