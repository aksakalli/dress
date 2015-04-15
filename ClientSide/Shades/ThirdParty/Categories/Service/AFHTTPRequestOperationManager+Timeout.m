//
//  AFHTTPRequestOperationManager+Timeout.m
//
//  Created by rsolmaz on 11/12/13.
//  Copyright (c) 2013 rsolmaz. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Timeout.h"

@implementation AFHTTPRequestOperationManager (Timeout)


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                timeoutInterval:(NSTimeInterval)timeoutInterval
                    cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error: nil];
    [request setTimeoutInterval:timeoutInterval];
    //[request setCachePolicy:cachePolicy];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                     cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error: nil];
    [request setTimeoutInterval:timeoutInterval];
    //[request setCachePolicy:cachePolicy];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
@end
