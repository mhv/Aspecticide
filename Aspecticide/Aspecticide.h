//
//  Aspecticide.h
//  Aspecticide
//
//  Created by Mikhail Vroubel on 22/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import <UIKit/UIKit.h>

// ! Project version number for Aspecticide.
FOUNDATION_EXPORT double AspecticideVersionNumber;

// ! Project version string for Aspecticide.
FOUNDATION_EXPORT const unsigned char AspecticideVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Aspecticide/PublicHeader.h>

#warning optimization preserves type?
#warning property params unused

// mixin must conform to @AspectType
@protocol MixinType
@end

// aspect must conform to @AspectType
@protocol AspectType
@end

// +inject or #Aspectialize(#Aspectify) class for aspects to work
@interface Aspecticide : NSObject
+ (void)inject:(Class)cls;
@end

#import "Property.h"
#import "Defines.h"
#import "Aspecticide+aspects.h"
#import "Aspecticide+mixins.h"
