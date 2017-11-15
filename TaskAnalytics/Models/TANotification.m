//
//  TANotification.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TANotification.h"

@implementation TANotification

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary{
    
    if (self = [super init]) {
        
        
        NSString* body =                dictionary[@"body"];
        NSNumber* timeout =             dictionary[@"timeout"];
        NSString* title =               dictionary[@"title"];
        
        
        if (body == nil|| timeout == nil  || title == nil){
            
            return nil;
            
        }
        
        
        
        self.body = body;
        self.timeout = timeout.intValue;
        self.title = title;
        
    }
    
    
    return self;
}

@end
