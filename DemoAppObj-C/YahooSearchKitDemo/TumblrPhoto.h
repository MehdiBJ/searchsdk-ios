//
//  TumblrPhoto.h
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import <Foundation/Foundation.h>

@interface TumblrPhoto : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *postUrl;
@property (nonatomic, strong) NSString *blogName;
@property (nonatomic, strong) NSString *noteCount;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *tagsString;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end


@interface TumblrPhotos : NSObject

@property (nonatomic, strong) NSMutableArray *photos;

- (instancetype)initWithResponseDictionaries:(NSArray*)responseDictionaries;

@end
