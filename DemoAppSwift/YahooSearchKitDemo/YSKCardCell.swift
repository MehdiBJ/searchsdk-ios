//
//  YSKCardCell.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

let cardTopBottomMargin: CGFloat = CGFloat(12.0)
let cardLeftRightMargin: CGFloat = CGFloat(8.0)

class YSKCustomCardCell: UITableViewCell {
    
    
    //--------------------------------------------------------------------------------------------------
    // MARK: Variables and Constants
    //--------------------------------------------------------------------------------------------------
    private var _frame:CGRect?
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UI elements
    //--------------------------------------------------------------------------------------------------
    var title: UILabel!
    var caption: UILabel!
    var tags: UILabel!
    var blogImage: UIImageView!
    var reblogImage: UIImageView!
    var likeImage: UIImageView!
    
    //--------------------------------------------------------------------------------------------------
    // MARK: UITableViewCell methods
    //--------------------------------------------------------------------------------------------------
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupStyle()
        self.addSubviews()
        self.addConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        blogImage.image = nil
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: View Hierarchy setup
    //--------------------------------------------------------------------------------------------------
    
    func addSubviews() {
        title = UILabel()
        title.textColor = UIColor.blackColor()
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(title)
        
        blogImage = UIImageView()
        blogImage.backgroundColor = UIColor.grayColor()
        blogImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        blogImage.contentMode = UIViewContentMode.ScaleAspectFill
        blogImage.clipsToBounds = true
        self.contentView.addSubview(blogImage)
        
        caption = UILabel()
        caption.textColor = UIColor.blackColor()
        caption.font = UIFont(name: "HelveticaNeue", size: 15.0)
        caption.setTranslatesAutoresizingMaskIntoConstraints(false)
        caption.numberOfLines = 3
        self.contentView.addSubview(caption)
        
        tags = UILabel()
        tags.textColor = UIColor(red: CGFloat(162.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(162.0/255.0), alpha: 1.0)
        tags.font = UIFont(name: "HelveticaNeue", size: 15.0)
        tags.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(tags)
        
        likeImage = UIImageView()
        likeImage.image = UIImage(named: "favorite.png")
        likeImage.tintColor = UIColor(red: CGFloat(162.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(162.0/255.0), alpha: 1.0)
        likeImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(likeImage)
        
        reblogImage = UIImageView()
        reblogImage.image = UIImage(named: "reblog.png")
        reblogImage.tintColor = UIColor(red: CGFloat(162.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(162.0/255.0), alpha: 1.0)
        reblogImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(reblogImage)
    }
    
    func addConstraints() {
        let viewsDictionary = ["title":title, "blogImage":blogImage, "caption":caption, "tags":tags, "likeImage":likeImage, "reblogImage":reblogImage]
        
        // Horizontal Constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[title]-16-|", options:NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blogImage]|", options:NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[caption]-16-|", options:NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[tags]-[reblogImage(19)]-6-[likeImage(19)]-16-|", options:NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraint(NSLayoutConstraint(item: likeImage, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: reblogImage, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: likeImage, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: tags, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // Vertical Constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[title]-16-[blogImage(210)]-16-[caption]-16-[likeImage(19)]-20-|", options:NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
    }
    
    func setupStyle() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.cornerRadius = 2.0
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSizeMake(2.5, 2.5)
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    override var frame:CGRect {
        set {
            _frame = newValue
            var temp:CGRect = newValue
            temp.origin.x += cardLeftRightMargin
            temp.size.width -= 2 * cardLeftRightMargin
            temp.size.height -= cardTopBottomMargin
            super.frame = temp
        }
        get {
            return _frame!
        }
    }
}
