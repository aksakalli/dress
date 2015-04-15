//
//  UIViewController+NetworkExtensions.h
//
//  Created by Ismail GULEK on 11/14/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFHTTPRequestOperation.h"
@interface UIViewController (ExtensionsOperationHandling)

@property (nonatomic, strong) NSMutableArray * networkOperations;

-(void) addNetworkOperation:(AFHTTPRequestOperation *)operation;
-(void) removeNetworkOperation:(AFHTTPRequestOperation *)operation;

-(void) cancelRequestsOfViewController;
-(void) cancelRequestsOfViewControllerStartingWith:(NSString *)startingPath;

@end
