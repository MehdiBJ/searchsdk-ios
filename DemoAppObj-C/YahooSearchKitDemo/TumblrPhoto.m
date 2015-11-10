//
//  TumblrPhoto.m
//  YahooSearchKitDemo
//
//  Copyright 2015 Yahoo! Inc.
//  Licensed under the terms of the zLib license. See LICENSE file at the root of this project for license terms.
//

#import "TumblrPhoto.h"

@implementation TumblrPhoto

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.imageUrl = dictionary[@"photos"][0][@"alt_sizes"][0][@"url"];
        self.postUrl = dictionary[@"post_url"];
        self.blogName = dictionary[@"blog_name"];
        self.noteCount = @"0";
        NSArray *tags = dictionary[@"tags"];
        [tags enumerateObjectsUsingBlock:^(id tag, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                self.tagsString = [NSString stringWithFormat:@"#%@", tag];
            } else {
                self.tagsString = [NSString stringWithFormat:@"%@ #%@", self.tagsString, tag];
            }
        }];
        self.caption = dictionary[@"caption"];
    }
    return self;
}

@end

@implementation TumblrPhotos
    
- (instancetype)init {
    self = [super init];
    if (self) {
        self.photos = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithResponseDictionaries:(NSArray*)responseDictionaries {
    self = [super init];
    if (self) {
        self.photos = [NSMutableArray new];
        
        for (NSDictionary *dict in responseDictionaries) {
            if (dict[@"photos"] != nil) {
                TumblrPhoto *photo = [[TumblrPhoto alloc] initWithDictionary:dict];
                if (![photo.imageUrl hasSuffix:@"gif"]) {
                    [self.photos addObject:photo];
                }
            }
        }
    }
    return self;
}

@end