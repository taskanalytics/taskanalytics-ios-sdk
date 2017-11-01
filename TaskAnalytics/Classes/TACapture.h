//
//  TACapture.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TACapture : NSObject

@property (nonatomic, assign) bool collect;
@property (nonatomic, assign) int excludeDays;
@property (nonatomic, strong, nonnull) NSString *title;
@property (nonatomic, strong, nonnull) NSURL *url;

@end
