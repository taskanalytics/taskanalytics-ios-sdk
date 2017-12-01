//
//  TACaptureWebViewController.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskAnalytics.h"

@import WebKit;

@interface TACaptureWebViewController : UIViewController

@property (nonatomic, weak) id <TaskAnalyticsDelegate>delegate;
@property (nonatomic, strong) NSURL* captureURL;
@property (nonatomic, strong) NSString* captureTitle;


@end
