//
//  Aspecticide.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide.h"

#import <objc/runtime.h>

#import "StretHelper.h"

@interface Property (Private)
+ (instancetype)propertyWith:(objc_property_t)property class:(Class)cls;
@end

@implementation Aspecticide

static NSMutableSet *_injecteded;

+ (void)initialize {
    _injecteded = [NSMutableSet set];
}

+ (void)inject:(Class)cls {
    @synchronized(cls) {
        if (![_injecteded containsObject:cls]) {
            [_injecteded addObject:cls];
            unsigned int count;
            Protocol *__unsafe_unretained *protos = class_copyProtocolList(cls, &count);
            
            for (int i = 0; i < count; i++) {
                Protocol *proto = protos[i];
                
                if (protocol_conformsToProtocol(proto, NSProtocolFromString(@"MixinType"))) {
                    [self class:cls addMixin:proto];
                }
            }
            
            objc_property_t *lst = class_copyPropertyList(cls, &count);
            Property *prop;
            
            for (int i = 0; i < count; i++) {
                if ((prop = [Property propertyWith:lst[i] class:cls])) {
                    if (prop.valueType) {
                        StretBase *stret = StretFactory(prop);
                        [self replaceGetterFor:prop stret:stret];
                        [self replaceSetterFor:prop stret:stret];
                        delete stret;
                    } else {
                        [self replaceGetterFor:prop stret:nil];
                        [self replaceSetterFor:prop stret:nil];
                    }
                }
            }
        }
    }
}

#pragma mark -

+ (void)replaceGetterFor:(Property *)prop stret:(StretBase *)stret {
    Class cls = prop.ownerClass;
    BOOL dirtyGet = NO;
    id (^getImpl)(id) = [self getImplForProperty:prop stret:stret];
    
    for (id aspect in prop.aspects.reverseObjectEnumerator) {
        SEL nextGet = NSSelectorFromString([NSString stringWithFormat:@"%@:next:", aspect]);
        
        if ([Aspecticide instancesRespondToSelector:nextGet]) {
            id (*propGet)(id, SEL, Property *, id) = (id (*)(id, SEL, Property *, id))class_getMethodImplementation([Aspecticide class], nextGet);
            getImpl = [^(id a) {
                return propGet(a, prop.getter, prop, getImpl);
            } copy];
            dirtyGet = YES;
        }
    }
    
    if (dirtyGet) {
        if (!prop.valueClass) {
            stret->ReplaceGetter(prop, getImpl);
        } else {
            class_replaceMethod(cls, prop.getter, imp_implementationWithBlock(getImpl), method_getTypeEncoding(class_getInstanceMethod(cls, prop.getter)));
        }
    }
}

+ (void)replaceSetterFor:(Property *)prop stret:(StretBase *)stret {
    Class cls = prop.ownerClass;
    void (^setImpl)(id, id) = [self setImplForProperty:prop stret:stret];
    BOOL dirtySet = NO;
    
    for (id aspect in prop.aspects.reverseObjectEnumerator) {
        SEL nextSet = NSSelectorFromString([NSString stringWithFormat:@"%@:next:set:", aspect]);
        
        if ([Aspecticide instancesRespondToSelector:nextSet]) {
            void (*propSet)(id, SEL, Property *, id, id) = (void (*)(id, SEL, Property *, id, id))class_getMethodImplementation([Aspecticide class], nextSet);
            setImpl = [^(id a, id x) {
                propSet(a, prop.setter, prop, setImpl, x);
            } copy];
            dirtySet = YES;
        }
    }
    
    if (dirtySet) {
        if (!prop.valueClass) {
            stret->ReplaceSetter(prop, setImpl);
        } else {
            class_replaceMethod(cls, prop.setter, imp_implementationWithBlock(setImpl), method_getTypeEncoding(class_getInstanceMethod(cls, prop.setter)));
        }
    }
}

+ (id (^)(id))getImplForProperty:(Property *)prop stret:(StretBase *)stret {
    Class cls = prop.ownerClass;
    id (*origGet)(id, SEL) = (id (*)(id, SEL))class_getMethodImplementation(cls, prop.getter);
    id (^getImpl)(id);
    
    if (prop.valueClass) {
        getImpl = [^(id a) {
            return origGet(a, prop.getter);
        } copy];
    } else {
        getImpl = stret->Getter(prop);
    }
    
    return getImpl;
}

+ (void (^)(id, id))setImplForProperty:(Property *)prop stret:(StretBase *)stret {
    Class cls = prop.ownerClass;
    void (*origSet)(id, SEL, id) = (void (*)(id, SEL, id))class_getMethodImplementation(cls, prop.setter);
    void (^setImpl)(id, id);
    
    if (prop.valueClass) {
        setImpl = [^(id a, id x) {
            origSet(a, prop.setter, x);
        } copy];
    } else {
        setImpl = stret->Setter(prop);
    }
    
    return setImpl;
}

+ (void)class:(Class)cls addMixin:(Protocol *)proto {
    unsigned int methCount;
    struct objc_method_description *meths = protocol_copyMethodDescriptionList(proto, NO, YES, &methCount);
    Class mixin = objc_lookUpClass(protocol_getName(proto));
    
    for (int j = 0; j < methCount; j++) {
        objc_method_description meth = meths[j];
        IMP impl = method_getImplementation(class_getInstanceMethod(mixin, meth.name));
        class_replaceMethod(cls, meth.name, impl, meth.types);
    }
}

@end
