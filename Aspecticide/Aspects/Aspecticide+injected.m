//
//  Aspecticide+injected.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide+aspects.h"


@implementation Aspecticide (injected)

- (id)injected:(Property *)prop next:(id (^)(id))next {
    static IMP lazy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lazy = [Aspecticide instanceMethodForSelector:@selector(lazy:next:)];
    });
    return ((id (*)(id, SEL, id, id))lazy)(self, _cmd, prop, next);
}

- (void)injected:(Property *)prop next:(void (^)(id, id))next set:(id)x {
    [(id < injected >) x setContext:self];
    next(self, x);
}

@end
