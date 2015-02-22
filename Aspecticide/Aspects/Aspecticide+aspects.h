//
//  Aspecticide+logged.h
//  Aspecticide
//
//  Created by Mikhail Vroubel on 18/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import "Aspecticide.h"

// make distinguashable highlight
#define lazy lazy
#define logged logged
#define associated associated
#define injected injected

// service aspects
Aspectface(lazy)
Aspectface(logged)
Aspectface(associated)

@protocol injected<AspectType>
@property (nonatomic, weak) id context;
@end

@interface Aspecticide (injected)
@end
