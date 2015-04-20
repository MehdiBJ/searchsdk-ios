//
//  YSKLandingPageViewController.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

class YSKLandingPageViewController: UIViewController {

    var backgroundImage:UIImage! {
        set {
            var mainImageView: UIImageView! = UIImageView()
            mainImageView.image = newValue
            mainImageView.frame = self.view.frame
            var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            var blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = mainImageView.bounds
            mainImageView.addSubview(blurView)
            self.view.addSubview(mainImageView)
 
        }
        get {
            return UIImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
