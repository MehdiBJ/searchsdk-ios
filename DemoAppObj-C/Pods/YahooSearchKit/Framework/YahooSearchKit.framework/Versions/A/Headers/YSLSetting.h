//
//  YSLSetting.h
//  YahooSearchKit
//
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YSLSearchProtocol;

/**
 *  Safe search modes supported by YahooSearchKit.
 */
typedef NS_ENUM(NSUInteger, YSLSafeSearchMode)
{
    /**
     This is the safest mode. When set, the search backend aggressively filters any offensive content from the search results.
     */
    YSLSafeSearchModeStrict = 0,
    
    /**
     Less aggressive filtering
     */
    YSLSafeSearchModeModerate,
    
    /**
     No filtering
     */
    YSLSafeSearchModeOFF
};

@interface YSLSetting : NSObject

/**
 *  Initializes YahooSearchKit with the application ID; You must initialize YahooSearchKit with a valid application ID.
 *
 *  @param appId    Application ID
 */
+ (void)setupWithAppId:(NSString *)appId;

/**
 *  Returns the singleton setting instance
 *
 *  @return singleton setting instance
 */
+ (YSLSetting *)sharedSetting;

/**
 *  Set this property to specify the level of filtering that the search backend must perform to remove offensive content from the search results.
 *  You can turn off safe search mode by setting it to YSLSafeSearchModeOFF. Default is YSLSafeSearchModeModerate.
 */
@property (nonatomic, assign) YSLSafeSearchMode safeSearchMode;

/**
 *  Set this property to indicate if developer mode is turned on or off. Default is YES.
 *
 *  In order to avoid tracking search and ad attribution information for any searches performed using your application while
 *  you are still developing it, YahooSearchKit provides a developer mode flag. It is set to YES by default. It is important that you set
 *  it to NO for your production build that you will submit to Apple. Otherwise any searches performed or ads clicked on using your 
 *  application will not receive attribution.
 */
@property (nonatomic, assign) BOOL developerMode;

/**
 * This controls tracking user location in search results.
 * Default is YES.
 */
@property (nonatomic, assign) BOOL trackUserLocation;

/**
 *  Registers the class for the search result type
 *
 *  @discussion Registers a YSLSearchProtocol compliant class to the search result type. Registering a duplicate search result type will raise exception.
 *  You can not register a class for default search result types YSLSearchResultTypeWeb, YSLSearchResultTypeImage, or YSLSearchResultTypeVideo. It will
 *  raise exception.
 *  This class will not be instantiated at the time of registration.
 *  If the desired resultType has to be displayed, the resultType has to be included in setSearchResultTypes API of YSLSearchViewController.
 *
 *  @param searchResultClass a class that will be instantiated for displaying the given search result type.
 *
 *  @param resultType a search result type identifier. You can not register for default result types YSLSearchResultTypeWeb, YSLSearchResultTypeImage, or YSLSearchResultTypeVideo.
 *  @returns BOOL to indicate if the registration was successful
 */
- (BOOL)registerSearchResultClass:(Class<YSLSearchProtocol>)searchResultClass forType:(NSString *)resultType;

/**
 *  Deregisters the class for the search result type
 *
 *  @discussion Deregisters a class from the search result type. If search result type to be unregistered is not registered already,
 *  it will return NO.
 *  You can not deregister a class for default search result types YSLSearchResultTypeWeb, YSLSearchResultTypeImage, or YSLSearchResultTypeVideo. It will
 *  raise exception.
 *
 *  @param resultType a search result type identifier.
 *
 *  @returns BOOL to indicate if the deregistration was successful
 */
- (BOOL)deregisterSearchResultType:(NSString *)resultType;

@end
