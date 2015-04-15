//
//  NSObject+NullRemoving.h
//
//  Created by Ismail GULEK on 8/12/13.
//  Copyright (c) 2013 Ismail GULEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NullRemoving)

-(BOOL) isNull;

//removes null objects recursively (also removes null objects from inner dictionaries), so objectForKey: returns nil
-(void) removeNulls;
-(id) objectWithoutNulls;

@end
