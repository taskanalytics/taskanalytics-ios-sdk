//
//  TAConsent.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TAConsent.h"

@implementation TAConsent

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary{
    
    if (self = [super init]) {
        
        NSString* title = dictionary[@"title"];

        
        
        if (title == nil){
            
            return nil;
            
        }
        
        self.title = title;
        
    }
    
    
    return self;
    
}

@end
