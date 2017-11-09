//
//  TAAvatar.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 09.11.2017.
//

#import "TAAvatar.h"

@implementation TAAvatar

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary{
    
    if (self = [super init]) {
        
        
        //Find the correct URL based on screen scale
        NSString* scale = [NSString stringWithFormat:@"%ix", (int)[UIScreen.mainScreen scale]];
        NSURL* url = [NSURL URLWithString:    dictionary[@"src"][scale]];

        
        if (url == nil){
            
            return nil;
            
        }
        
        self.url = url;
        
    }
    
    
    return self;
    
}

@end
