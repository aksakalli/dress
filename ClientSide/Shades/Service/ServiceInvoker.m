//
//  ServiceInvoker.m
//  Shades
//
//  Created by yücel uzun on 14/04/15.
//  Copyright (c) 2015 Yücel Uzun. All rights reserved.
//

#import "ServiceInvoker.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPRequestSerializer+Timeout.h"
#import "NSData+JSONUtilities.h"
#import "UIViewController+NetworkExtensions.h"

/// Defines the duration before the connection timeout occurs.
static CGFloat const TimeoutInterval = 30.0;

@implementation ServiceInvoker

#pragma mark - Class Methods
static ServiceInvoker * serviceInvoker = nil;

+ (ServiceInvoker *) serviceInvoker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceInvoker = [ServiceInvoker create];
    });
    return serviceInvoker;
}

+ (ServiceInvoker *) create
{
    ServiceInvoker * serviceInvoker = [[super alloc] init];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     { // Works when connection status changed.
         if (status == AFNetworkReachabilityStatusNotReachable)
         {
#warning What will be done if internet connection drops?
         }
         NSLog(@"Network Status: %@", AFStringFromNetworkReachabilityStatus (status));
     }];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return serviceInvoker;
}

#pragma mark - Object Methods

- (void) startNetworkMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark Service

#pragma mark POST
- (void) postToPath: (NSString *) path parameters: (NSDictionary *) parameters
          responseBlock: (void (^)(id, NSError *)) block fromViewController: (UIViewController *) controller
{
#warning url
    NSString * url = @"";
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod: @"POST"
                                                                                 URLString: url
                                                                                parameters: parameters
                                                                           timeoutInterval: TimeoutInterval];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    [self startOperation: operation block: block viewController: controller];
}

#pragma mark GET

- (void) getPath: (NSString *) path parameters: (NSDictionary *) parameters
         responseBlock: (void (^)(id, NSError *))block fromViewController: (UIViewController *)controller
{
#warning URL
    NSURL * url = [NSURL URLWithString: @""];
    [self makeGetRequestToURL: url responseBlock: block fromViewController: controller];
}

- (void) getURL: (NSString *) urlString responseBlock: (void (^)(id, NSError *))block
         fromViewController: (UIViewController *)controller
{
    NSURL * url = [NSURL URLWithString: urlString];
    [self makeGetRequestToURL: url responseBlock: block fromViewController: controller];
}

- (void) makeGetRequestToURL: (NSURL *) url responseBlock: (void (^)(id, NSError *))block
          fromViewController: (UIViewController *)controller
{
    NSMutableURLRequest * request   = [[NSMutableURLRequest alloc] initWithURL:url];
    
    __block AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    [self startOperation: operation block: block viewController: controller];
}

#pragma mark Operation

- (void) startOperation: (AFHTTPRequestOperation *) operation
                  block: (void (^)(id, NSError *))block
         viewController: (UIViewController *) controller
{
    
    if(![AFNetworkReachabilityManager sharedManager].reachable)
    {
        NSError *error = [NSError errorWithDomain: @"Shades" code: INTERNET_NOT_REACHABLE userInfo:nil];
        block(nil,error);        return;
    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [responseObject JSONObject];
         
         if (!result) {
             result = (NSData *) responseObject;
         }
         
         if(block) {
             block(result,nil);
         }
         
         [controller removeNetworkOperation:operation];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ %@", operation.request.URL, [error localizedDescription]);
         
         if(block) {
             block(nil,error);
         }
         
         [controller removeNetworkOperation:operation];
     }];
    
    if(controller) {
        [controller addNetworkOperation:operation];
    } else {
        [operation start];
    }
}



@end
