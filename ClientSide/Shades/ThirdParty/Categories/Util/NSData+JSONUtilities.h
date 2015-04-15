//
//  NSData+JSONUtilities.h
//
//  Created by Ismail GULEK on 8/6/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSONParseBlock) (id object, NSError * error);
typedef void (^JSONSerializeBlock) (NSData * data, NSError * error);

@interface NSData (JSONUtilities)

//parse
-(id) JSONObject;
-(void) parseAsJSONObjectWithBlock:(JSONParseBlock)block;

//serialize
+(NSData *) dataWithJSONObject:(id)object;
+(void) dataWithJSONObject:(id)object withBlock:(JSONSerializeBlock)block;

@end
