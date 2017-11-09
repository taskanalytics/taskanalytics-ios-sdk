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

+ (NSURL*)setupURLWithBaseURL: (NSURL*) baseURL{
    
    
    NSURLComponents* components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:false];
    
    //Create query items
    
    NSString* device = deviceName();
    NSString* os = [NSString stringWithFormat:@"%@ %@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];
    NSString* UUID = [NSUserDefaults.standardUserDefaults stringForKey:kTAUUID];

    
    NSURLQueryItem* deviceQueryItem = [NSURLQueryItem queryItemWithName:@"device" value:device];
    NSURLQueryItem* osQueryItem = [NSURLQueryItem queryItemWithName:@"os" value:os];
    NSURLQueryItem* UUIDQueryItem = [NSURLQueryItem queryItemWithName:@"uuid" value:UUID];
    
    components.queryItems = @[deviceQueryItem, osQueryItem, UUIDQueryItem];
    
    
    return [components URL];
    
}

@end
