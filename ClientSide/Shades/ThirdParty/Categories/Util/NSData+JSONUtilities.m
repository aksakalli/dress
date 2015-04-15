//
//  NSData+JSONUtilities.m
//
//  Created by Ismail GULEK on 8/6/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import "NSData+JSONUtilities.h"
#import "NSObject+NullRemoving.h"
@implementation NSData (JSONUtilities)

-(id) JSONObject
{
    return [[NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil]  objectWithoutNulls];
}

-(void) parseAsJSONObjectWithBlock:(JSONParseBlock)block
{
    NSError * error;
    id object = [[NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error] objectWithoutNulls];
    if(block)
        block(object, error);
}

+(NSData *) dataWithJSONObject:(id)object
{
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
}

+(void) dataWithJSONObject:(id)object withBlock:(JSONSerializeBlock)block
{
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if(block)
        block(data, error);
}

@end
