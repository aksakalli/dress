//
//  AFHTTPRequestOperationManager+Timeout.h
//
//  Created by rsolmaz on 11/12/13.
//  Copyright (c) 2013 rsolmaz. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPRequestOperationManager (Timeout)


-(AFHTTPRequestOperation *)GET:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
               timeoutInterval:(NSTimeInterval)timeoutInterval
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                     cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
