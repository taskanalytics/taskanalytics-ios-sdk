//
//  TAConsentViewController.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TAConsentViewController.h"
#import "TACaptureWebViewController.h"
#import "TAConsentButton.h"

@interface TAConsentViewController ()

@end

@implementation TAConsentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.clearColor;
    
    
    //Add tap gesture recognizer
    UITapGestureRecognizer* tapGestureRegonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGestureRegonizer];
    
    
    
    ////////////////////////
    // Visual effect view //
    ////////////////////////
    
    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = self.view.bounds;
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = false;

    [self.view addSubview:visualEffectView];
    
    [visualEffectView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [visualEffectView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [visualEffectView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [visualEffectView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    
    
    //////////////
    // Top line //
    //////////////
    
    UIView* topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1]; //10% black
    topLineView.translatesAutoresizingMaskIntoConstraints = false;
    
    [visualEffectView.contentView addSubview:topLineView];
    
    [topLineView.heightAnchor constraintEqualToConstant:1].active = true;
    [topLineView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [topLineView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [topLineView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    
    
    /////////////////
    // Bottom line //
    /////////////////
    
    UIView* bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1]; //10% black
    bottomLineView.translatesAutoresizingMaskIntoConstraints = false;
    
    [visualEffectView.contentView addSubview:bottomLineView];
    
    [bottomLineView.heightAnchor constraintEqualToConstant:1].active = true;
    [bottomLineView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [bottomLineView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [bottomLineView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    
    ////////////
    // Button //
    ////////////
    
    float buttonWidth = 48;
    
    TAConsentButton *consentButton = [[TAConsentButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    consentButton.userInteractionEnabled = false;
    consentButton.translatesAutoresizingMaskIntoConstraints = false;
    [consentButton setImage:self.avatarImage forState:UIControlStateNormal];

    [visualEffectView.contentView addSubview:consentButton];
    
    [consentButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = true;
    [consentButton.heightAnchor constraintEqualToConstant:buttonWidth].active = true;
    [consentButton.widthAnchor constraintEqualToConstant:buttonWidth].active = true;
    [consentButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    
    
    ///////////
    // Label //
    ///////////
    
    UILabel* label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.text = self.consentTitle;
    
    [visualEffectView.contentView addSubview:label];

    [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = true;
    
    [label.trailingAnchor constraintEqualToAnchor:consentButton.leadingAnchor constant:-10].active = true;

    
}



- (void)viewTapped:(id)sender {
    
    [self.delegate consentButtonPressed];
    
}


@end
