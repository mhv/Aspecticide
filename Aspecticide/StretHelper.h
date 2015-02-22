//
//  StretHelper.h
//  Aspecticide Sample
//
//  Created by Mikhail Vroubel on 20/02/2015.
//  Copyright (c) 2015 my. All rights reserved.
//

@class Property;
class StretBase {
public:
    virtual void ReplaceGetter(Property *prop, id (^getImpl)(id)) = 0;
    
    virtual void ReplaceSetter(Property *prop, void (^setImpl)(id, id)) = 0;
    
    virtual id Setter(Property *prop) = 0;
    
    virtual id Getter(Property *prop) = 0;
    
    virtual ~StretBase() {
    };
};

StretBase *StretFactory(Property *p);
