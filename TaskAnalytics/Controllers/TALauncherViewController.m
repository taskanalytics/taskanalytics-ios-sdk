//
//  TALauncherViewController.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 04.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TALauncherViewController.h"
#import "TACaptureWebViewController.h"
#import "TaskAnalytics.h"
#import "TALauncherButton.h"

@interface TALauncherViewController ()

@end

@implementation TALauncherViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    TALauncherButton *launcherButton = [[TALauncherButton alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
    launcherButton.translatesAutoresizingMaskIntoConstraints = false;
    [launcherButton addTarget:self action:@selector(launcherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [launcherButton setImage:self.avatarImage forState:UIControlStateNormal];

    [self.view addSubview:launcherButton];
    
    [launcherButton.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [launcherButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [launcherButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [launcherButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    
}

- (void)launcherButtonPressed:(id)sender {
    
    [self.delegate launcherButtonPressed];
    
}

@end
