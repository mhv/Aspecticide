//
//  NJect.h
//  Aspecticide
//
//  Created by Mikhail Vroubel on 17/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Aspecticide/Aspecticide.h>

@interface NJect : NSObject

@property (nonatomic, assign) int STRET(stretProp, logged);

@property (nonatomic, assign) CGRect STRET(rectProp, logged);

@property (nonatomic, assign) CGSize STRET(sizeProp, logged);

@end

@interface NJecto : NSObject <injected>
@property (nonatomic, weak) id context;
@end

@interface NJecty : NJect <Mixy>

@property (nonatomic, strong) Mixy<lazy> *Mixy;
@property (nonatomic, strong) NJecto<injected> *injecteded;
@property (nonatomic, strong) NSString<NSCopying, lazy> *mixedProp;

// - (id<logged>)map:(id<logged>)some;

@end

@interface NJecty (AR)
@property (nonatomic, strong) NSString<logged, lazy, associated> *arProp;
@end
