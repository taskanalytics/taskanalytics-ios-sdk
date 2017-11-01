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
}

@end

@implementation TACaptureWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.captureTitle;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lukk" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
    
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
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                  configuration:configuration];
    
    // Load the URL into the WKWebView and then add it as a sub-view.
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:self.captureURL];
    [_webView loadRequest:urlRequest];
    
    [self.view addSubview:_webView];

}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [_webView evaluateJavaScript:@"onCaptureOpen()" completionHandler:nil];

    
}



#pragma mark - Buttons

- (void) closeButtonPressed:(id)sender{
    
    [_webView evaluateJavaScript:@"onCaptureClose()" completionHandler:nil];
    
    [self.delegate closeButtonPressed];
    
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
            
            [self.delegate captureFinished];

        }
    }
}

@end
