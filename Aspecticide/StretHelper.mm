//
//  StretHelper.cpp
//  Aspecticide Sample
//
//  Created by Mikhail Vroubel on 20/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#include "StretHelper.h"

#import <objc/runtime.h>
#import <CoreGraphics/CGGeometry.h>

#import "Property.h"

template <class T> class Stret : public StretBase {
public:
    void ReplaceGetter(Property *prop, id (^getImpl)(id)) {
        IMP impl = imp_implementationWithBlock((T (^)(id))[^(id a) {
            T x;
            [getImpl(a) getValue:&x];
            return x;
        } copy]);
        class_replaceMethod(prop.ownerClass, prop.getter, impl, method_getTypeEncoding(class_getInstanceMethod(prop.ownerClass, prop.getter)));
    }
    
    void ReplaceSetter(Property *prop, void (^setImpl)(id, id)) {
        IMP impl = imp_implementationWithBlock((void (^)(id, T))[^(id a, T x) {
            setImpl(a, [NSValue value:&x withObjCType:prop.valueType]);
        } copy]);
        class_replaceMethod(prop.ownerClass, prop.setter, impl, method_getTypeEncoding(class_getInstanceMethod(prop.ownerClass, prop.setter)));
    }
    
    id Setter(Property *prop) {
        void (*origSet)(id, SEL, T) = (void (*)(id, SEL, T))class_getMethodImplementation(prop.ownerClass, prop.setter);
        return [^(id a, NSValue *val) {
            T x;
            [val getValue:&x];
            origSet(a, prop.setter, x);
        } copy];
    }
    
    id Getter(Property *prop) {
        T (*origGet)(id, SEL) = (T (*)(id, SEL))class_getMethodImplementation(prop.ownerClass, prop.getter);
        return [^(id a) {
            T x = origGet(a, prop.getter);
            return [NSValue value:&x withObjCType:prop.valueType];
        } copy];
    }
    
};

// XXX
#define FACTOR(type) if (!strcmp(p.valueType, @encode(type))) {return new Stret<type>; }
StretBase *StretFactory(Property *p) {
    FACTOR(char);
    FACTOR(int);
    FACTOR(long);
    FACTOR(unsigned int);
    FACTOR(unsigned long);
    FACTOR(float);
    FACTOR(double);
    FACTOR(CGSize);
    FACTOR(CGRect);
    FACTOR(void *);
    return new Stret<__unsafe_unretained id>;
}
