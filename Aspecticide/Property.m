//
//  Property.m
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Property.h"

#import <objc/runtime.h>

@implementation Property

static const char *prefix = "STRET";

+ (instancetype)propertyWith:(objc_property_t)property class:(Class)cls {
    Property *prop = nil;
    char *t = property_copyAttributeValue(property, "T");
    NSArray *types = [[NSString stringWithCString:t encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"<"];
    NSMutableArray *aspects = [NSMutableArray array];
    
    for (int i = 1; i < types.count; i++) {
        id aspect = [types[i] substringToIndex:[types[i] rangeOfString:@">"].location];
        
        if (protocol_conformsToProtocol(NSProtocolFromString(aspect), NSProtocolFromString(@"AspectType"))) {
            [aspects addObject:aspect];
        }
    }
    
    if (aspects.count) {
        prop = [self new];
        prop.ownerClass = cls;
        prop.aspects = aspects;
        const char *name = property_getName(property);
        const char *tmp = name;
        int i = 0;
        
        while (i < 5 && prefix[i] == name[i]) { // XXX trash
            i++;
        }
        
        if (i == 5) {
            name = &tmp[5];
            property = class_getProperty(cls, name);
            prop.valueType = property_copyAttributeValue(property, "T");
        }
        
        prop.name = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
        tmp = property_copyAttributeValue(property, "G");
        prop.getter = sel_getUid(tmp ? tmp : name);
        tmp = property_copyAttributeValue(property, "S");
        prop.setter = tmp ? sel_getUid(tmp) :
        
        NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[prop.name substringToIndex:1] capitalizedString], [prop.name substringFromIndex:1]]);
        
        id t = types[0];
        t = [t substringFromIndex:[t rangeOfString:@"\""].location + 1];
        prop.valueClass = NSClassFromString(t);
    }
    
    return prop;
}

@end
