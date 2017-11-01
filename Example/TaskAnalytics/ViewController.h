//
//  ViewController.h
//  Task Analytics Example
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TaskAnalytics/TaskAnalytics.h>

@interface ViewController : UIViewController<TaskAnalyticsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serverURLTextField;

@end

