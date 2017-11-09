//
//  TAUtils.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 09.11.2017.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TAErrorType) {
    kTADidNotRunSetup,
    kTACouldNotParseJSON,
    kTAShouldNotCollect,
    kTAWaitToCollectAgain
};


@interface TAUtils : NSObject

+ (NSURL*)setupURLWithBaseURL: (NSURL*) baseURL;
+ (NSError*)errorWithErrorType:(TAErrorType) errorType;

@end

