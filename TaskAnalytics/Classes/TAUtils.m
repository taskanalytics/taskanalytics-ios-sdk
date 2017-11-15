//
//  TAUtils.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 09.11.2017.
//

#import "TAUtils.h"
#import "TaskAnalytics.h"
#import <sys/utsname.h>
#import "TAConstants.h"

@implementation TAUtils


NSString* deviceName(){
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSURL*)setupURLWithURL: (NSURL*) URL{
    
    
    NSURLComponents* components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:false];
    
    //Create query items
    
    NSString* UUID = [NSUserDefaults.standardUserDefaults stringForKey:kTAUUID];
    
    NSURLQueryItem* UUIDQueryItem = [NSURLQueryItem queryItemWithName:@"uuid" value:UUID];
    
    components.queryItems = @[UUIDQueryItem];
    
    return [components URL];
    
}

+ (NSURL*)captureURLWithURL: (NSURL*) URL{
    
    
    NSURLComponents* components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:false];
    
    //Create query items
    
    NSString* device = deviceName();
    NSString* os = [NSString stringWithFormat:@"%@ %@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];

    
    NSURLQueryItem* deviceQueryItem = [NSURLQueryItem queryItemWithName:@"device" value:device];
    NSURLQueryItem* osQueryItem = [NSURLQueryItem queryItemWithName:@"os" value:os];
    
    components.queryItems = @[deviceQueryItem, osQueryItem];
    
    
    return [components URL];
    
}

+ (NSError*)errorWithErrorType:(TAErrorType) errorType{
    
    
    NSDictionary<NSErrorUserInfoKey,id>* userInfo;
    
    switch (errorType) {
        case kTADidNotRunSetup:
            
            userInfo = @{NSLocalizedDescriptionKey: @"Setup has not been run yet."};
            break;
            
        case kTACouldNotParseJSON:
            
            userInfo = @{NSLocalizedDescriptionKey: @"Could not parse setup JSON."};
            break;
            
        case kTAShouldNotCollect:
            
            userInfo = @{NSLocalizedDescriptionKey: @"Should not collect."};
            break;
            
        case kTAWaitToCollectAgain:
            
            userInfo = @{NSLocalizedDescriptionKey: @"Wait to collect again."};
            break;

        default:
            break;
    }
    
    
    return [NSError errorWithDomain:kTAErrorDomain code:errorType userInfo:userInfo];
    
}

@end
