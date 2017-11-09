//
//  ViewController.m
//  Task Analytics Example
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TaskAnalytics.sharedInstance.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [TaskAnalytics.sharedInstance setConsentButtonVerticalDistance:49 fromEdge:TAEdgeBottom];
    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:20+49 fromCorner:TACornerBottomRight];
    
}

#pragma mark - Buttons

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.serverURLTextField resignFirstResponder];
    
    NSURL* url = [NSURL URLWithString:self.serverURLTextField.text];
    
    TaskAnalytics.sharedInstance.serverURL = url;
    
}


- (IBAction)setupButtonPressed:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* ID = alertController.textFields.firstObject.text;
        
        self.title = [NSString stringWithFormat:@"Task Analytics (ID: %@)", ID];
        
        [TaskAnalytics.sharedInstance setupWithID:ID];
        
    }];
    
    okAction.enabled = false;
    
    [alertController addAction:okAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            okAction.enabled = textField.text.length > 0;
        }];
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
    
    
}

- (IBAction)showButtonPressed:(id)sender {
    
    [TaskAnalytics.sharedInstance show];
    
}

- (IBAction)hideButtonPressed:(id)sender {
    
    [TaskAnalytics.sharedInstance hide];
    
}

- (IBAction)resetButtonPressed:(id)sender {
    
    [TaskAnalytics.sharedInstance reset];
    
}


- (IBAction)consentButtonTopButtonPressed:(id)sender {
    
    [TaskAnalytics.sharedInstance setConsentButtonVerticalDistance:28 fromEdge:TAEdgeTop];
    
}

- (IBAction)consentButtonBottomButtonPressed:(id)sender {
    
    [TaskAnalytics.sharedInstance setConsentButtonVerticalDistance:49 fromEdge:TAEdgeBottom];
    
}

- (IBAction)launcherButtonTopLeftButtonPressed:(id)sender {
    
    //On iPhone, the statusbar + navigationbar is 64 points tall
    
    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:64+20 fromCorner:TACornerTopLeft];
    
}

- (IBAction)launcherButtonTopRightButtonPressed:(id)sender {
    
    //On the iPhone, the statusbar + navigationbar is 64 points tall

    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:64+20 fromCorner:TACornerTopRight];
    
}

- (IBAction)launcherButtonBottomRightButtonPressed:(id)sender {
    
    //On the iPhone, the tab bar is 49 points tall
    
    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:49+20 fromCorner:TACornerBottomRight];
    
}

- (IBAction)launcherButtonBottomLeftButtonPressed:(id)sender {
    
    //On the iPhone, the tab bar is 49 points tall
    
    [TaskAnalytics.sharedInstance setLauncherButtonHorizontalDistance:20 verticalDistance:49+20 fromCorner:TACornerBottomLeft];
}



#pragma mark - TaskAnalyticsDelegate


-(void)consentButtonPressed{
    
    NSLog(@"Consent button pressed");
    
}

-(void)closeButtonPressed{
    
    NSLog(@"Close button pressed");
    
}

-(void)launcherButtonPressed{
    
    NSLog(@"Launcher button pressed");
    
}
-(void)consentAccepted{
    
    NSLog(@"Consent accepted");
    
}
-(void)consentDeclined{
    
    NSLog(@"Consent declined");
    
}
-(void)captureFinished{
    
    NSLog(@"Capture finished");
    
}

-(void)captureDestroy{
    
    NSLog(@"Capture destroy");
    
}

@end
