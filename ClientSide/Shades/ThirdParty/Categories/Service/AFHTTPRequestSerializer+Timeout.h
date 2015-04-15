//
//  AFHTTPRequestSerializer+Timeout.h
//
//  Created by rsolmaz on 11/12/13.
//  Copyright (c) 2013 rsolmaz. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface AFHTTPRequestSerializer (Timeout)

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                           timeoutInterval:(NSTimeInterval)timeoutInterval;
@end
