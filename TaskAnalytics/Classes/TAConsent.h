//
//  TAConsent.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAConsent : NSObject

@property (nonatomic, strong, nonnull) NSString * title;

- (id _Nullable)initWithDictionary:(NSDictionary* _Nonnull) dictionary;

@end
