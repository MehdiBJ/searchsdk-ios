//
//  YSKCustomHeader.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

enum YSCHeaderViewMode: Int {
    // Header is in normal mode
    case NormalMode = 0
    // Header is in edit mode and focus is on textField
    case ActiveEditMode
    // Header is in edit mode but focus is not on textField
    case PassiveEditMode
}

/* Optional - enum types for different types of themes */
enum YSCHeaderViewTheme: Int {
    case White = 0
    case Dark
    case Transparent
    case Tumblr
}

class YSKCustomHeader: UIView, UITextFieldDelegate, YSLHeaderProtocol {
    
    /*--------------------------------------------------------------------------------------------------
    -----------------------------------------MARK: REQUIRED---------------------------------------------
    --------------------------------------------------------------------------------------------------*/
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UI elements
    //--------------------------------------------------------------------------------------------------
    
    var contentView : UIView! = UIView()
    var leftButton  : UIButton!
    var textField   : UITextField!
    var cancelButton: UIButton!
    var border      : UIView!
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIColor for custom themes
    //--------------------------------------------------------------------------------------------------
    
    private var textColor: UIColor! = UIColor.blackColor()
    private var placeholderColor: UIColor! = UIColor.grayColor()
    private var leftButtonColor: UIColor! = UIColor.blackColor()
    private var borderColor: UIColor! = UIColor.blackColor()
    private var cancelButtonColor: UIColor! = UIColor.blackColor()
    private var headerBackgroundColor: UIColor! = UIColor.whiteColor()
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Implementation
    //--------------------------------------------------------------------------------------------------
    var delegate: YSLHeaderDelegate!
    var originalQuery: String!
    private var _progressPercentage : CGFloat!
    private var _headerMode: YSCHeaderViewMode = YSCHeaderViewMode.NormalMode
    var headerMode: YSCHeaderViewMode {
        set {
            if (_headerMode != newValue) {
                if newValue == YSCHeaderViewMode.NormalMode {
                    toggleUIToNormalMode()
                } else if (newValue == YSCHeaderViewMode.ActiveEditMode) {
                    toggleUIToEditMode()
                }
                
                if (newValue != YSCHeaderViewMode.ActiveEditMode) {
                    self.textField.resignFirstResponder()
                }
                _headerMode = newValue
            }
        }
        get {
            return _headerMode
        }
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: YSLHeaderProtocol
    //--------------------------------------------------------------------------------------------------
    let maximumHeight: CGFloat = 66.0
    let minimumHeight: CGFloat = 20.0
    
    var progressPercentage: CGFloat {
        set {
            _progressPercentage = newValue
        }
        get {
            return _progressPercentage
        }
    }
    
    var queryString:String! {
        set {
            self.textField.text = newValue
        }
        get {
            return self.textField.text
        }
    }
    
    var placeHolderString:String! {
        set {
            self.textField.placeholder = newValue
        }
        get {
            return self.textField.placeholder!
        }
    }
    
    func dismissKeyboard() {
        if (self.headerMode == YSCHeaderViewMode.ActiveEditMode) {
            self.textField.resignFirstResponder()
            self.headerMode = YSCHeaderViewMode.PassiveEditMode
        }
    }
    
    var editing:Bool {
        set {
            var mode: YSCHeaderViewMode!
            if (newValue) {
                mode = YSCHeaderViewMode.ActiveEditMode
            } else {
                mode = YSCHeaderViewMode.NormalMode
            }
            self.headerMode = mode
            if (newValue) {
                self.textField.becomeFirstResponder()
            }
        } @objc(isEditing) get {
            return (self.headerMode != YSCHeaderViewMode.NormalMode)
        }
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Initialization
    //--------------------------------------------------------------------------------------------------
    
    init() {
        // Note: No need to provide frame, constraints will position the footer based on maximumHeight & minimumHeight accordingly
        super.init(frame: CGRectZero)
        /* Setup view Hierarchy */
        setupViews()
        
        /* Start in Normal Mode */
        toggleUIToNormalMode()
        
        /* Add constraints for content View */
        contentView.addConstraints(contentViewConstraints() as Array)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: View Hierarchy setup
    //--------------------------------------------------------------------------------------------------
    
    func setupViews() {
        
        // Setup content view
        contentView.backgroundColor = UIColor.clearColor()
        contentView.clipsToBounds = true
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(contentView)
        
        // Setup left button
        leftButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leftButton.addTarget(self, action: "leftButtonTapped:", forControlEvents: .TouchUpInside)
        leftButton.backgroundColor = UIColor.clearColor()
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        leftButton.setImage(UIImage(named: "LeftArrow.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        leftButton.tintColor = leftButtonColor
        leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(leftButton)
        
        // Setup text field
        textField = UITextField(frame: CGRectMake(0.0, 0.0, 100.0, 30.0))
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.font = UIFont(name: "HelveticaNeue", size: 17.0)
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string:"Search",
            attributes:[NSForegroundColorAttributeName: placeholderColor])
        textField.tintColor = textColor
        textField.textColor = textColor
        contentView.addSubview(textField)
        var clearButton: UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        clearButton.setImage(UIImage(named: "ClearButton"), forState: .Normal)
        clearButton.frame = CGRectMake(0.0, 0.0, 20.0, 20.0)
        clearButton.alpha = 0.6
        clearButton.addTarget(self, action: "clearButtonTapped:", forControlEvents: .TouchUpInside)
        textField.rightView = clearButton
        textField.rightViewMode = UITextFieldViewMode.WhileEditing
        
        
        // Setup cancel button
        cancelButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: .TouchUpInside)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.setTitle("Cancel" , forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        cancelButton.tintColor = cancelButtonColor
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(cancelButton)
        
        // Border
        border = UIView()
        border.backgroundColor = borderColor
        border.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(border)
        
        // Constraints
        let viewsDictionary = ["contentView":contentView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[contentView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Constraints
    //--------------------------------------------------------------------------------------------------
    
    func contentViewConstraints() -> NSMutableArray! {
        var contentViewConstraints: NSMutableArray! = []
        let viewsDictionary = ["contentView":contentView, "leftButton":leftButton,"textField":textField, "cancelButton":cancelButton, "border":border]
        
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("V:[textField(20)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("H:[textField(>=30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("H:[leftButton(44)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("V:[leftButton(44)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("H:[cancelButton(50)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(20)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("H:|[border]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("V:[border(1)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        contentViewConstraints.addObject(NSLayoutConstraint(item: leftButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentViewConstraints.addObject(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentViewConstraints.addObject(NSLayoutConstraint(item: cancelButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentViewConstraints.addObjectsFromArray(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[leftButton]-[textField]-[cancelButton]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        
        return contentViewConstraints
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Utilities
    //--------------------------------------------------------------------------------------------------
    func toggleUIToNormalMode() {
        cancelButton.enabled = false
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.cancelButton.alpha = 0.0
        })
    }
    
    func toggleUIToEditMode() {
        cancelButton.enabled = true
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.cancelButton.alpha = 1.0
        })
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UIButton Target actions
    //--------------------------------------------------------------------------------------------------
    func leftButtonTapped(sender:UIButton!) {
        self.delegate.leftButtonTappedInHeaderView(self)
    }
    
    func clearButtonTapped(sender:UIButton!) {
        textField.text = ""
        self.delegate.header(self, didChangeQueryString: "")
    }
    
    func cancelButtonTapped(sender:UIButton!) {
        headerMode = YSCHeaderViewMode.NormalMode
        
        var currentQuery:NSString! = textField.text
        textField.text = originalQuery
        originalQuery = nil
        toggleUIToNormalMode()
        
        self.delegate.header(self, didCancelEditingQueryString: currentQuery as String!)
        self.delegate.cancelButtonTappedInHeaderView(self)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UITextFieldDelegate
    //--------------------------------------------------------------------------------------------------
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.delegate.header(self, didChangeQueryString: "")
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (self.headerMode == YSCHeaderViewMode.NormalMode) {
            self.originalQuery = textField.text
            self.delegate.header(self, willBeginEditingQueryString: textField.text)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if headerMode == YSCHeaderViewMode.NormalMode {
            self.delegate.header(self, didBeginEditingQueryString: textField.text)
        }
        headerMode = YSCHeaderViewMode.ActiveEditMode
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newQuery = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        self.delegate.header(self, didChangeQueryString: newQuery)
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var shouldReturn: Bool = false
        self.headerMode = YSCHeaderViewMode.NormalMode
        self.delegate.header(self, didEndEditingQueryString: textField.text)
        shouldReturn = true
        
        return shouldReturn
    }
    
    /*--------------------------------------------------------------------------------------------------
    -----------------------------------------MARK: OPTIONAL---------------------------------------------
    --------------------------------------------------------------------------------------------------*/
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Custom initialization
    //--------------------------------------------------------------------------------------------------
    
    init(theme:YSCHeaderViewTheme) {
        super.init(frame: CGRectZero)
        /* Setup Theme */
        switch (theme) {
        case .Dark:
            headerBackgroundColor = UIColor(red: CGFloat(25.0/255.0), green: CGFloat(25.0/255.0), blue: CGFloat(27.0/255.0), alpha: 1.0)
            textColor = UIColor.whiteColor()
            borderColor = UIColor.clearColor()
            leftButtonColor = UIColor.whiteColor()
            cancelButtonColor = UIColor.whiteColor()
            placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            break
        case .White:
            headerBackgroundColor = UIColor.whiteColor()
            leftButtonColor = UIColor(red: CGFloat(65.0/255.0), green: 0.0, blue: CGFloat(144.0/255.0), alpha: 1.0)
            textColor = UIColor.blackColor()
            borderColor = UIColor(red: CGFloat(213.0/255.0), green: CGFloat(213.0/255.0), blue: CGFloat(213.0/255.0), alpha: 1.0)
            cancelButtonColor = UIColor(red: CGFloat(127.0/255.0), green: CGFloat(127.0/255.0), blue: CGFloat(127.0/255.0), alpha: 1.0)
            placeholderColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            break
        case .Transparent:
            headerBackgroundColor = UIColor(red: CGFloat(111.0/255.0), green: CGFloat(139.0/255.0), blue: CGFloat(191.0/255.0), alpha: 1.0)
            leftButtonColor = UIColor.whiteColor()
            textColor = UIColor.whiteColor()
            borderColor = UIColor.clearColor()
            cancelButtonColor = UIColor.whiteColor()
            placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            break
        case .Tumblr:
            headerBackgroundColor = UIColor(red: CGFloat(46.0/255.0), green: CGFloat(63.0/255.0), blue: CGFloat(83.0/255.0), alpha: 1.0)
            leftButtonColor = UIColor.whiteColor()
            textColor = UIColor.whiteColor()
            borderColor = UIColor.clearColor()
            cancelButtonColor = UIColor.whiteColor()
            placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
            break
        }
        self.backgroundColor = headerBackgroundColor
        
        /* Setup view Hierarchy */
        setupViews()
        
        /* Start in Normal Mode */
        toggleUIToNormalMode()
        
        /* Add constraints for content View */
        contentView.addConstraints(contentViewConstraints() as Array)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
