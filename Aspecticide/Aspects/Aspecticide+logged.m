//
//  Aspecticide+logged.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 18/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide+aspects.h"

Aspectment(logged)

@implementation Aspecticide (logged)

- (id)logged:(Property *)prop next:(id (^)(id))next {
    id x = next(self);
    NSLog(@"%@ - %@ get %@", self, prop.name, x);
    return x;
}

- (void)logged:(Property *)prop next:(void (^)(id, id))next set:(id)x {
    NSLog(@"%@ - %@ will set %@", self, prop.name, x);
    next(self, x);
    NSLog(@"%@ - %@ did set %@", self, prop.name, x);
}

@end
