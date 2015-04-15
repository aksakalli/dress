//
//  NSObject+NullRemoving.m
//
//  Created by Ismail GULEK on 8/12/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import "NSObject+NullRemoving.h"

@implementation NSObject (NullRemoving)

//added as method instead of comparising to [NSNull null] object, because null comparison can change after
-(BOOL) isNull
{
    return [self isKindOfClass:[NSNull class]];
}

-(void) removeNulls
{
    //empty implementation for base object
}

-(id) objectWithoutNulls
{
    if([self isNull])
        return nil;
    [self removeNulls];
    return self;
}

@end

@implementation NSMutableArray (NullRemoving)

-(void) removeNulls
{
    for(id object in self)
    {
        if([object isNull])
            [self removeObject:object];
        else
            [object removeNulls];
    }
}

@end

@implementation NSMutableDictionary (NullRemoving)

-(void) removeNulls
{
    for (NSObject * key in [self allKeys])
    {
        id object = [self objectForKey:key];
        
        if([object isNull])
            [self removeObjectForKey:key];
        else
            [object removeNulls];
    }
}

@end


