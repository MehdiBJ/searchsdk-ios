//
//  TumblrPhotos.swift
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

import UIKit

struct TumblrPhoto {
    
    var imageUrl: String!
    var postUrl: String!
    var blogName: String!
    var caption: String! = ""
    var tagsString: String! = ""
    
    init(dictionary: NSDictionary) {
        imageUrl = ((((dictionary["photos"] as! NSArray)[0] as! NSDictionary)["alt_sizes"] as! NSArray)[0] as! NSDictionary)["url"] as! String
        postUrl = dictionary["post_url"] as! String
        blogName = dictionary["blog_name"] as! String
        if (dictionary["caption"] != nil) {
            caption = dictionary["caption"] as! String
        }
        let tags: NSArray! = dictionary["tags"] as! NSArray
        tagsString = tags.componentsJoinedByString(",")
    }
    
}

struct TumblrPhotos {
    
    var photos: [TumblrPhoto]!
    
    init() {
        photos = Array()
    }
    
    init(responseDictionaries : [NSDictionary]) {
        photos = Array()
        for (var i = 0; i < responseDictionaries.count; i++) {
            if (responseDictionaries[i]["photos"] != nil) {
                let photo: TumblrPhoto! = TumblrPhoto(dictionary: responseDictionaries[i])
                if (photo.imageUrl.hasSuffix("gif") == false) {
                    photos.append(photo)
                }
            }
        }
    }
}
