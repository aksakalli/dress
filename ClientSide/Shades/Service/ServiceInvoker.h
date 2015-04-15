//
//  ServiceInvoker.h
//  Shades
//
//  Created by yücel uzun on 14/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;
/// Error code for disconnected status.
static NSUInteger const INTERNET_NOT_REACHABLE = -101;

@interface ServiceInvoker : NSObject

/// Returns serviceInvoker singleton.
+ (ServiceInvoker *) serviceInvoker;

- (void) startNetworkMonitoring;

/**
 Makes a "POST" request to given path.
 @param path POST request will be send at API_URL+path
 @param parameters POST parameters
 @param responseBlock Same block is executed both in success in failure. 
 @param fromViewController View controller which makes request. Can be nil if there isn't any.
 */
- (void) postToPath: (NSString *) path parameters: (NSDictionary *) parameters
       responseBlock: (void (^)(id, NSError *)) block fromViewController: (UIViewController *) controller;

/**
 Makes a "GET" request to given path.
 @param path GET request will be send at API_URL+path
 @param parameters Parameters like page number which will be added to URL
 @param responseBlock Same block is executed both in success in failure.
 @param fromViewController View controller which makes request. Can be nil if there isn't any.
 */
- (void) getPath: (NSString *) path parameters: (NSDictionary *) parameters
        responseBlock: (void (^)(id, NSError *))block fromViewController: (UIViewController *)controller;

/**
 Makes a "GET" request to given url string.
 @param urlString GET request will be send to this URL
 @param responseBlock Same block is executed both in success in failure.
 @param fromViewController View controller which makes request. Can be nil if there isn't any.
 */
- (void) getURL: (NSString *) urlString responseBlock: (void (^)(id, NSError *))block
        fromViewController: (UIViewController *)controller;


@end
