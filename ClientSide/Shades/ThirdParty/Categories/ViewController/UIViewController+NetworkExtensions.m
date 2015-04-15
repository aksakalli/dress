//
//  UIViewController+NetworkExtensions.m
//
//  Created by Ismail GULEK on 11/14/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import "UIViewController+NetworkExtensions.h"
#import "AFHTTPRequestOperation.h"
#import <objc/runtime.h>

static char const * const NetworkOperationArrayKey	= "NetworkOperationArrayKey";

@implementation UIViewController (ExtensionsOperationHandling)

-(void) addNetworkOperation:(AFHTTPRequestOperation *)operation
{
	[self.networkOperations addObject:operation];
	[operation start];
}

-(void) removeNetworkOperation:(AFHTTPRequestOperation *)operation
{
	[operation setCompletionBlockWithSuccess:NULL failure:NULL];
	[operation cancel];
	[self.networkOperations removeObject:operation];
	operation = nil;
}

-(NSMutableArray *) networkOperations
{
    NSMutableArray * networkOperations = objc_getAssociatedObject(self, NetworkOperationArrayKey);
    if (networkOperations == nil)
    {
		networkOperations = [[NSMutableArray alloc] init];
        [self setNetworkOperations:networkOperations];
	}
    return networkOperations;
}

-(void) setNetworkOperations:(NSMutableArray *)networkOperations
{
    objc_setAssociatedObject(self, NetworkOperationArrayKey, networkOperations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) cancelRequestsOfViewController
{
	for(AFHTTPRequestOperation * operation in self.networkOperations)
		[operation cancel];
	[self.networkOperations removeAllObjects];
}

-(void) cancelRequestsOfViewControllerStartingWith:(NSString *)startingPath
{
	NSMutableArray * operationsToDelete = [[NSMutableArray alloc] init];
	for(AFHTTPRequestOperation * operation in self.networkOperations)
	{
		if([[[operation.request URL] path] hasPrefix:startingPath])
		{
			[operation cancel];
			[operationsToDelete addObject:operation];
		}
	}
	
	[self.networkOperations removeObjectsInArray:operationsToDelete];
}

@end




