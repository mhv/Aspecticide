//
//  Defines.h
//  Aspecticide
//
//  Created by Mikhail Vroubel on 18/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

// TODO: use some convention to allow primitive properties
// @property (nonatomic, assign) int STRET(someInt, logged);
#define STRET(name, ...) name; @property (nonatomic, assign, readonly) id<__VA_ARGS__> STRET ## name;

// #Aspectialize class for aspects to work on provided class and its subclasses
#define Aspectialize(cls) @interface cls (Aspectialize) @end\
@implementation cls (Aspectialize) + (void)initialize {[Aspecticide inject:self]; } @end

// #Aspectify class for aspects to work on provided class only
#define Aspectify(cls) @interface cls (Aspectify) @end\
@implementation cls (Aspectify) + (void)load {[Aspecticide inject:self]; } @end

// #Aspectface new aspect in header, then #Aspectment in source.
#define Aspectface(aspect) @protocol aspect<AspectType> @end\
@interface NSObject (aspect)<aspect> @end\
@protocol aspect ## _internal @optional\
- (id)aspect:(Property *)prop next:(id (^)(id))next;\
- (void)aspect:(Property *)prop next:(void (^)(id, id))next set:(id)x;\
@end\
@interface Aspecticide (aspect) <aspect ## _internal> @end

// #Aspectface new aspect in header, then #Aspectment in source
#define Aspectment(aspect) @implementation NSObject (aspect) @end

#define Mixinface(Mixin) @protocol Mixin;\
@interface Mixin : NSObject @end\
@protocol Mixin <MixinType> @required @property (nonatomic, strong, readonly) Mixin *Mixin; @optional
