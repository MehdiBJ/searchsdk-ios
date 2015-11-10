//
//  YSLTrendingCategories.h
//  YahooSearchLibrary
//
//  Created by Benjamin Lin on 4/2/15.
//  Copyright (c) 2015 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YSLTrendingCategory)
{
    YSLTrendingCategoryNone = -1,
    YSLTrendingCategoryDefault = 0,
    YSLTrendingCategoryNews,
    YSLTrendingCategorySports,
    YSLTrendingCategoryCelebrity
};