//
//  TANotification.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TANotification : NSObject

@property (nonatomic, strong, nonnull) NSString * title;
@property (nonatomic, strong, nonnull) NSString * body;
@property (nonatomic, assign) int timeout;

@end
