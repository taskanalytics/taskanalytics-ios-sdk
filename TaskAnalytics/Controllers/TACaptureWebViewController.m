//
//  TACaptureWebViewController.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 27.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TACaptureWebViewController.h"

@interface TACaptureWebViewController (){
    
    WKWebView *_webView;
    BOOL isCaptureFinish;
}

@end

@implementation TACaptureWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isCaptureFinish = false;
    
    self.title = self.captureTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lukk" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:self.captureURL];

    [_webView loadRequest:urlRequest];
    
    
}


- (void)loadView{
    
    [super loadView];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    
    // Add a script handler for the "observe" call. This is added to every frame
    // in the document (window.webkit.messageHandlers.NAME).
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;
    
    
    
    // Initialize the WKWebView with the current frame and the configuration
    // setup above
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                  configuration:configuration];
    
    self.view = _webView;
    
}



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    [_webView evaluateJavaScript:@"onCaptureOpen()" completionHandler:nil];

    
    //Start listenening to keyboard notifications
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
 
    [_webView evaluateJavaScript:@"onKeyboardResize(0)" completionHandler:nil];
    
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSString* javaScript = [NSString stringWithFormat:@"onKeyboardResize(%f)", keyboardFrame.size.height];
    
    [_webView evaluateJavaScript:javaScript completionHandler:nil];

}



#pragma mark - Buttons

- (void) closeButtonPressed:(id)sender{
    
    if (isCaptureFinish == true) {
        
        [self.delegate captureDestroyed];
        
    }
    else{
        
        [_webView evaluateJavaScript:@"onCaptureClose()" completionHandler:nil];
        
        [self.delegate closeButtonPressed];
    
    }
    
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    // Check to make sure the name is correct
    if ([message.name isEqualToString:@"observe"]) {
        
        if ([message.body isEqualToString:@"onConsentAccept"]){
            
            [self.delegate consentAccepted];
            
        }
        else if ([message.body isEqualToString:@"onConsentDecline"]){
            
            [self.delegate consentDeclined];
            
        }
        else if ([message.body isEqualToString:@"onCaptureFinish"]){
            
            isCaptureFinish = true;
            
            [self.delegate captureFinished];

        }
        else if ([message.body isEqualToString:@"onCaptureDestroy"]){
            
            [self.delegate captureDestroyed];
            
        }
    }
}

@end
