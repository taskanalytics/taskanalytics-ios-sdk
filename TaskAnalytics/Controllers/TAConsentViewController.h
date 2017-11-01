//
//  TATriggerViewController.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskAnalytics.h"

@interface TAConsentViewController : UIViewController

@property (nonatomic, strong) NSString *consentTitle;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, weak) id <TaskAnalyticsDelegate>delegate;

@end
