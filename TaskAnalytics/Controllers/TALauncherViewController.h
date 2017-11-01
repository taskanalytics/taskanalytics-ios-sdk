//
//  TALauncherViewController.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 04.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskAnalytics.h"


@interface TALauncherViewController : UIViewController

@property (nonatomic, weak) id <TaskAnalyticsDelegate>delegate;
@property (nonatomic, strong) UIImage *avatarImage;


@end
