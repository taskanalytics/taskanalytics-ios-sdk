//
//  TACapture.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TACapture.h"

@implementation TACapture

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary{
    
    if (self = [super init]) {
        
        NSNumber* collect =                  dictionary[@"collect"];
        NSNumber* excludeDays =              dictionary[@"excludeDays"];
        NSString* title =                    dictionary[@"title"];
        NSURL* url = [NSURL URLWithString:   dictionary[@"url"]];
        
        
        if (collect == nil|| excludeDays == nil  || title == nil || url == nil){
            
            return nil;
    
        }
    
        self.collect = collect.boolValue;
        self.excludeDays = excludeDays.intValue;
        self.title = title;
        self.url = url;
        
    }
    
    
    return self;
    
}

@end
