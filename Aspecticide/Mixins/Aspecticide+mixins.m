//
//  Aspecticide+mixins.m
//  Aspecticide Sample
//
//  Created by Mikhail Vroubel on 20/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide+mixins.h"

// #import <objc/runtime.h>

@interface Mixy () <Mixy>
@property (nonatomic, assign) int mixo;
@end

@implementation Mixy
@dynamic Mixy;

- (void)mixMeth {
    self.Mixy.mixo += 11;
    NSLog(@"%@ %@", @"!mixed!", @(self.Mixy.mixo));
}

@end
