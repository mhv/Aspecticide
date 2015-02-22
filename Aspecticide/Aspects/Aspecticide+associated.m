//
//  Aspecticide+associated.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 18/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide+aspects.h"

#import <objc/runtime.h>

Aspectment(associated)

@implementation Aspecticide (associated)

- (id)associated:(Property *)prop next:(id (^)(id))next {
    return objc_getAssociatedObject(self, prop.getter);
}

- (void)associated:(Property *)prop next:(void (^)(id, id))next set:(id)x {
    objc_setAssociatedObject(self, prop.getter, x, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
