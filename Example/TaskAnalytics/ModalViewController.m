//
//  ModalViewController.m
//  TaskAnalytics Example
//
//  Created by Andreas Schjønhaug on 27.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "ModalViewController.h"
#import <TaskAnalytics/TaskAnalytics.h>

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [TaskAnalytics.sharedInstance setConsentButtonVerticalDistance:0 fromEdge:TAEdgeBottom];
    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:20 fromCorner:TACornerBottomRight];
    
}




#pragma mark - Buttons

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}



@end
