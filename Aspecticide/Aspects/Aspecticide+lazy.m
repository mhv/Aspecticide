//
//  Aspecticide+lazy.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide+aspects.h"

Aspectment(lazy)

@implementation Aspecticide (lazy)

- (id)lazy:(Property *)prop next:(id (^)(id))next {
    id res = next(self);
    
    if (!res) {
        res = [prop.valueClass new];
        [self performSelector:prop.setter withObject:res];
    }
    
    return next(self);
}

@end
