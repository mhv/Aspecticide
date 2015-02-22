//
//  Property.h
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) Class ownerClass;
@property (nonatomic) Class valueClass;
@property (nonatomic) char *valueType;
@property (nonatomic) SEL getter;
@property (nonatomic) SEL setter;
@property (nonatomic) NSArray *aspects;

@end
