//
//  TAAvatar.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 09.11.2017.
//

#import <Foundation/Foundation.h>

@interface TAAvatar : NSObject

@property (nonatomic, strong, nonnull) NSURL *url;

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary;

@end
