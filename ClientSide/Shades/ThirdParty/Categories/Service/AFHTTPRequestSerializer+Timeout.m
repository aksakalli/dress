//
//  AFHTTPRequestSerializer+Timeout.m
//
//  Created by rsolmaz on 11/12/13.
//  Copyright (c) 2013 rsolmaz. All rights reserved.
//

#import "AFHTTPRequestSerializer+Timeout.h"

@implementation AFHTTPRequestSerializer (Timeout)


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                           timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:timeoutInterval];
    request = [[self requestBySerializingRequest:request withParameters:parameters error:nil] mutableCopy];
    
	return request;
}

@end
