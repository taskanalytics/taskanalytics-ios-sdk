//
//  TaskAnalytics.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskAnalytics.h"
#import "TAConsentViewController.h"
#import "TALauncherViewController.h"
#import "TACaptureWebViewController.h"

#import "TACapture.h"
#import "TAConsent.h"
#import "TANotification.h"


NSString * _Nonnull const kTAUUID = @"TA-UUID";
NSString * _Nonnull const kTAAvatarURL = @"TA-avatar-url";
NSString * _Nonnull const kTAAvatarImageData = @"TA-avatar-image-data";
NSString * _Nonnull const kTADateForParticiationDeclinedOrFinished = @"TA-date-for-participation-declined-or-finished";
NSString * _Nonnull const kTALocalNotification = @"TALocalNotification";

int const kTATriggerViewHeight = 64;
int const kTADoneViewSize = 54;

@interface TaskAnalytics()<TaskAnalyticsDelegate>
{
    //Models from JSON setup
    TACapture* _capture;
    TAConsent* _consent;
    TANotification* _notification;
    
    TAConsentViewController* _consentViewController;
    TALauncherViewController* _launcherViewController;
    TACaptureWebViewController* _captureWebViewController;

    UIWindow *_window;
    dispatch_semaphore_t _semaphore;
    
    BOOL _consentGiven;
    
    
    //Consent view
    float _consentViewVerticalDistance;
    TAEdge _consentViewEdge;
    
    
    //Launcher view
    float _launcherViewHorizontalDistance;
    float _launcherViewVerticalDistance;
    TACorner _launcherViewCorner;
    
    
}
@end

@implementation TaskAnalytics

+ (instancetype)sharedInstance {
    
    static TaskAnalytics *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
    
}


#pragma mark - Public methods


- (void)setupWithID:(nonnull NSString*)ID{
    
    
    //Listen for when the app enters the background
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    
    _consentGiven = false;

    
    //First, check to see if we need to generate a UUID
    
    NSString* UUID = [NSUserDefaults.standardUserDefaults stringForKey:kTAUUID];
    
    if (UUID == nil){
        
        UUID = [[[NSUUID alloc] init] UUIDString];
        
        //Save it in NSUserDefaults
        [NSUserDefaults.standardUserDefaults setObject:UUID forKey:kTAUUID];
        [NSUserDefaults.standardUserDefaults synchronize];
        
    }
    
    
    NSURL* serverURL;
    
    if (self.serverURL != nil){
        
        serverURL = self.serverURL;
        
    }
    else{
        
        serverURL = [[[NSURL URLWithString:@"http://ios-capture.taskanalytics.com/setup"] URLByAppendingPathComponent:ID] URLByAppendingPathComponent:UUID];
        //Debug serverURL = [NSURL URLWithString:@"http://localhost:3000/db"];
        
    }
    
    
    
    [self loadJSONFromServerURL:serverURL];
    
    
}


- (void)setConsentButtonVerticalDistance:(float)points fromEdge:(TAEdge)edge{
    
    _consentViewVerticalDistance = points;
    _consentViewEdge = edge;
    
    if (_consentGiven == false && _window.rootViewController == _consentViewController){
        
        [self moveConsentViewWithAnimation:true];

    }
    
    
}

- (void)setLauncherButtonHorizontalDistance:(float)horizontalDistance verticalDistance:(float)verticalDistance fromCorner:(TACorner)corner{

    _launcherViewHorizontalDistance = horizontalDistance;
    _launcherViewVerticalDistance = verticalDistance;
    _launcherViewCorner = corner;
    
    if (_consentGiven == true && _window.rootViewController == _launcherViewController){
        
        [self moveLauncherViewWithAnimation:true];
        
    }
}


- (void)show{
    

    
    //If the window was previously just hidden, we only need to make it visible again
    
    if (_window.hidden == true){
        
        _window.hidden = false;
        
        [UIView animateWithDuration:0.2 animations:^{

            _window.alpha = 1;
            
            
        } completion:nil];
        
        return;
    }
  
    
    //Check to see if setup has run, i.e. semaphore is not equal nil
    
    if (_semaphore == nil){
        
        //Fail silently
        return;
        
    }
    
    
    
    //First, we need to check if it's time to show Task Analytics
    
    
    //Wait for the setup to be loaded from server.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _semaphore = nil;
            
            // capture, consent and notification are not set, something went wrong in the JSON parsing, and we abort
            //We don't check the avatar and avatar URL in NSUserDefault, because they might be there from before.
            
            if (_capture == nil || _consent == nil || _notification == nil){
                
                return; //Silent fail
            }
            
            
            //Check if the capture form is active
            
            if (_capture.collect == false){
                return; //Silent fail

            }
            
            
            
            NSDate* date = (NSDate*)[NSUserDefaults.standardUserDefaults objectForKey:kTADateForParticiationDeclinedOrFinished];
            
            
            if (date != nil){
                
                //Check the number of days
                
                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = _capture.excludeDays;
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDate *waitUntilDate = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
                
                //NSLog(@"Wait until: %@ ...", waitUntilDate);
                
                if ([waitUntilDate compare:[[NSDate alloc] init]] == NSOrderedAscending) {

                   [self showViewController];
                
                }
                
                
            }
            else{
                [self showViewController];
            }
            
        });
        
    });
    
}





- (void) hide{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _window.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        _window.hidden = true;
        
    }];
    
}



- (void) reset{
    
    //Remove all values from NSUserDefaults
    
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kTAUUID];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kTAAvatarURL];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kTAAvatarImageData];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:kTADateForParticiationDeclinedOrFinished];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    [self remove];
    
}



#pragma mark - Private methods


- (void)loadJSONFromServerURL:(NSURL *)serverURL {
    
    
    _semaphore = dispatch_semaphore_create(0);
    
    
    
    
    NSURLSession* urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[urlSession dataTaskWithURL:serverURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil){
            
            dispatch_semaphore_signal(_semaphore);
            return;  //Fail silently
            
        }
        
        NSError* jsonError = nil;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError != nil){
            
            dispatch_semaphore_signal(_semaphore);
            return;  //Fail silently
            
        }
        
        
        //NSLog(@"Dictionary %@", dictionary);
        
        //////////////////
        // Parsing JSON //
        //////////////////
        
        
        NSNumber* captureCollect =                  dictionary[@"setup"][@"capture"][@"collect"];
        NSNumber* captureExcludeDays =              dictionary[@"setup"][@"capture"][@"excludeDays"];
        NSString* captureTitle =                    dictionary[@"setup"][@"capture"][@"title"];
        NSURL* captureURL = [NSURL URLWithString:   dictionary[@"setup"][@"capture"][@"url"]];
        
        NSString* consentTitle =                    dictionary[@"setup"][@"consent"][@"title"];

        NSString* notificationBody =                dictionary[@"setup"][@"notification"][@"body"];
        NSNumber* notificationTimeout =             dictionary[@"setup"][@"notification"][@"timeout"];
        NSString* notificationTitle =               dictionary[@"setup"][@"notification"][@"title"];
        
        //Find the correct URL based on screen scale
        NSString* scale = [NSString stringWithFormat:@"%ix", (int)[UIScreen.mainScreen scale]];
        NSURL* avatarURL = [NSURL URLWithString:    dictionary[@"setup"][@"avatar"][@"src"][scale]];

        
        // Check that all values are present
        
        if (captureCollect == nil|| captureExcludeDays == nil  || captureTitle == nil || captureURL == nil ||
            consentTitle == nil ||
            notificationBody == nil || notificationTimeout == nil || notificationTitle == nil ||
            avatarURL == nil){
            
            dispatch_semaphore_signal(_semaphore);
            return; //Fail silently
        }
        
        
        
        //Create objects
        
        _capture = [[TACapture alloc] init];
        _capture.collect = [captureCollect boolValue];
        _capture.excludeDays = [captureExcludeDays intValue];
        _capture.title = captureTitle;
        _capture.url = captureURL;
        
        _consent = [[TAConsent alloc] init];
        _consent.title = consentTitle;
        
        _notification = [[TANotification alloc] init];
        _notification.body = notificationBody;
        _notification.title = notificationTitle;
        _notification.timeout = [notificationTimeout intValue];
        
        
        //Check if we should collect
        
        if (_capture.collect == false){
            
            dispatch_semaphore_signal(_semaphore);
            return; //Fail silently
        }
        

        //Set up the web view
        _captureWebViewController = [[TACaptureWebViewController alloc] init];
        
        _captureWebViewController.delegate = self;
        _captureWebViewController.captureURL = _capture.url;
        _captureWebViewController.captureTitle = _capture.title;
        
        //Preload the capture URL
        [_captureWebViewController.view setNeedsLayout];
        
        ///////////////////////////
        // Download avatar image //
        ///////////////////////////
        
        
        //Check if the image URL has changed. If so, download the new image
        
        if ([[NSUserDefaults.standardUserDefaults URLForKey:kTAAvatarURL] isEqual:avatarURL] == false){
            
            [[NSURLSession.sharedSession dataTaskWithURL:avatarURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                //Check to see if we have downloaded an actual image
                if ([UIImage imageWithData:data] != nil){
                    
                    //Save URL and image data to NSUserDefaults
                    [NSUserDefaults.standardUserDefaults setObject:data forKey:kTAAvatarImageData];
                    [NSUserDefaults.standardUserDefaults setURL:avatarURL forKey:kTAAvatarURL];
                    [NSUserDefaults.standardUserDefaults synchronize];
                    
                    dispatch_semaphore_signal(_semaphore);
                }
                
            }] resume];
            
            
            
        }
        else{
            
            dispatch_semaphore_signal(_semaphore);
            
        }
        
        
    }] resume];
}

- (void)remove{
    
    //Nil all the view controllers and window
    
    _consentViewController = nil;
    _launcherViewController = nil;
    _captureWebViewController = nil;
    
    _window = nil;
    
    //Remove listener
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
}


- (void)showViewController{
    
    
    if (_consentGiven == false){
        
        [self showConsentViewController];
        
    }
    else{
        
        [self showLauncherViewController];
        
    }
    
}

- (void)showConsentViewController{
    
  
    if (_window.rootViewController == nil){

        
        
        _consentViewController = [[TAConsentViewController alloc] init];
        _consentViewController.delegate = self;
        _consentViewController.consentTitle = _consent.title;
        
        
        //Show the avatar
        
        NSData* avatarImageData = [NSUserDefaults.standardUserDefaults dataForKey:kTAAvatarImageData];
        
        if (avatarImageData != nil){
            UIImage* image = [UIImage imageWithData:avatarImageData];
            
            _consentViewController.avatarImage = image;
            
        }
        
        
        
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTATriggerViewHeight)];
        
        _window.backgroundColor = UIColor.clearColor;
        _window.rootViewController = _consentViewController;
        
        
        _window.hidden = false;
        
        
        [self moveConsentViewWithAnimation:false];
        
        
    }
    
}


- (void)moveConsentViewWithAnimation:(BOOL)animation{
    
    
    float y = 0;
    
    switch (_consentViewEdge) {
        case TAEdgeTop:
            y = _consentViewVerticalDistance;
            break;
            
        case TAEdgeBottom:
            y = [UIScreen mainScreen].bounds.size.height - kTATriggerViewHeight - _consentViewVerticalDistance;
            break;
    }
    
    
    CGRect frame = _window.frame;
    frame.origin.y = y;
    
    
    if (CGRectEqualToRect(frame, _window.frame) == false){
        
        if (animation == true){
            
            [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _window.frame = frame;
                
            } completion:nil];
        }
        else{
            
            //This is the first time its displayed, so we move it into place, using a mask on the window
            
            _window.frame = frame;
            _window.layer.masksToBounds = true;
            
            //Move the consent view "off" screen
            
            switch (_consentViewEdge) {
                case TAEdgeTop:
                    _consentViewController.view.frame = CGRectMake(0, -_consentViewController.view.frame.size.height, frame.size.width, frame.size.height);
                    break;
                    
                case TAEdgeBottom:
                    _consentViewController.view.frame = CGRectMake(0, _consentViewController.view.frame.size.height, frame.size.width, frame.size.height);
                    break;
            }
            
            // Create a mask layer and the frame to determine what will be visible in the view.
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            CGRect maskRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            // Create a path with the rectangle in it.
            CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
            
            // Set the path to the mask layer.
            maskLayer.path = path;
            
            // Release the path since it's not covered by ARC.
            CGPathRelease(path);
            
            // Set the mask of the view.
            _window.layer.mask = maskLayer;
            
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _consentViewController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

                
            } completion:^(BOOL finished) {
                
                _window.layer.masksToBounds = false;
                _window.layer.mask = nil;
                
            }];
            
           
            
        }
        
        
        
    }
    
    
    
}


- (void)showLauncherViewController{
    
    if (_window.rootViewController != _launcherViewController){
        
        _launcherViewController = [[TALauncherViewController alloc] init];
        _launcherViewController.delegate = self;
        
        NSData* avatarImageData = [NSUserDefaults.standardUserDefaults dataForKey:kTAAvatarImageData];
        
        if (avatarImageData != nil){
            UIImage* image = [UIImage imageWithData:avatarImageData];
            
            _launcherViewController.avatarImage = image;
            
        }
        
        
        _window.rootViewController = _launcherViewController;

        _consentViewController = nil;

    }
    
}


- (void)moveLauncherViewWithAnimation:(BOOL)animation{
    
    //Calculate x and y of the done view
    
    float width = kTADoneViewSize;
    float height = kTADoneViewSize;
    float x;
    float y;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    switch (_launcherViewCorner) {
        case TACornerTopRight:
            
            x = screenWidth - _launcherViewHorizontalDistance - width;
            y = _launcherViewVerticalDistance;
            
            break;
            
        case TACornerBottomRight:
            
            x = screenWidth - _launcherViewHorizontalDistance - width;
            y = screenHeight - _launcherViewVerticalDistance - height;
            
            break;
            
        case TACornerBottomLeft:
            
            x = _launcherViewHorizontalDistance;
            y = screenHeight - _launcherViewVerticalDistance - height;
            
            break;
            
            
        case TACornerTopLeft:
            
            x = _launcherViewHorizontalDistance;
            y = _launcherViewVerticalDistance;
            
            break;
            
    }
    
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    if (CGRectEqualToRect(frame, _window.frame) == false){
        
        if (animation == true){
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _window.frame = frame;

            } completion:nil];
            
            
        }
        else{
            
            //This is the first time its displayed, so we "zoom" it into place
            
            _window.frame = frame;
            _window.transform = CGAffineTransformMakeScale(0, 0);
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _window.transform = CGAffineTransformMakeScale(1, 1);

                
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
        
    }
    
    
}


- (void)setDateForParticiationDeclinedOrFinished{
    
    NSDate* date = [[NSDate alloc] init];
    
    [NSUserDefaults.standardUserDefaults setObject:date forKey:kTADateForParticiationDeclinedOrFinished];
    [NSUserDefaults.standardUserDefaults synchronize];
    
}


#pragma mark - TaskAnalyticsDelegate

- (void)consentButtonPressed {
    
    
    [self showWebViewControllerAnimated:true];

    //Callback
    if ([self.delegate respondsToSelector:(@selector(consentButtonPressed))]){
        [self.delegate consentButtonPressed];
    }
    
    
}


- (void)closeButtonPressed{
    
    
    if (_window.rootViewController == _consentViewController){
        
        
        _consentViewController.view.alpha = 0;
        
        CGRect frame = _consentViewController.view.frame;
        
        [_window.rootViewController dismissViewControllerAnimated:true completion:^{
            
            
            _window.frame = frame;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _consentViewController.view.alpha = 1;
                
            }];
            
            
        }];
        
    }
    else if (_window.rootViewController == _launcherViewController){
        
        _launcherViewController.view.alpha = 0;
        
        CGRect frame = _launcherViewController.view.frame;
        
        [_window.rootViewController dismissViewControllerAnimated:true completion:^{
            
            _window.frame = frame;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _launcherViewController.view.alpha = 1;
                
            }];
            
            
        }];
        
    }
    
    //Callback
    if ([self.delegate respondsToSelector:(@selector(closeButtonPressed))]){
        [self.delegate closeButtonPressed];
    }
    
}


- (void)launcherButtonPressed {
    
    
    [self showWebViewControllerAnimated:true];
    
    //Callback
    if ([self.delegate respondsToSelector:(@selector(launcherButtonPressed))]){
        [self.delegate launcherButtonPressed];
    }
    
    
}


- (void)showWebViewControllerAnimated:(BOOL)animated{
    
    
    
    //Show the web view
    
    //First, we need to create a new frame for the consent and/or launcher view where it's positioned correctly within a full screen view

    
    
    //Set the window to full screen
    
    if (_window.rootViewController == _consentViewController){
        
        //First, we need to create a new frame for the trigger view where it's positioned correctly within a full screen view
        CGRect consentViewFrame = _consentViewController.view.frame;
        consentViewFrame.origin.y = _window.frame.origin.y;
        
        _window.frame = [[UIScreen mainScreen] bounds];
        
        //Set the consent view's new frame
        _consentViewController.view.frame = consentViewFrame;
        
    }
    else if (_window.rootViewController == _launcherViewController){
        
        CGRect launcherViewFrame = _launcherViewController.view.frame;
        launcherViewFrame.origin.x = _window.frame.origin.x;
        launcherViewFrame.origin.y = _window.frame.origin.y;
        
        _window.frame = [[UIScreen mainScreen] bounds];
        
        //Set the launcher view's new frame
        _launcherViewController.view.frame = launcherViewFrame;
        
    }
    
    
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:_captureWebViewController];
    
    [_window.rootViewController presentViewController:navigationController animated:animated completion:^{
       
       
    }];
    
    
    
}





- (void)consentAccepted{
    
    _consentViewController.view.hidden = true;
    _consentViewController = nil;
    
    _consentGiven = true;
    
    //Show done view
    [_window.rootViewController dismissViewControllerAnimated:true completion:^{
        
        [self showLauncherViewController];
        [self moveLauncherViewWithAnimation:false];
        
    }];
    
    //Callback
    if ([self.delegate respondsToSelector:(@selector(consentAccepted))]){
        [self.delegate consentAccepted];
    }
    
    
    
    //Ask for permission to show notification
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;

    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
                          
                          }];
    
    
    
}


- (void)consentDeclined{
    
    [self setDateForParticiationDeclinedOrFinished];
    
    _consentViewController.view.hidden = true;
    
    [_window.rootViewController dismissViewControllerAnimated:true completion:^{
       
        [self remove];
        
    }];
    
    
    
    //Callback
    if ([self.delegate respondsToSelector:(@selector(consentDeclined))]){
        [self.delegate consentDeclined];
    }
    
    
}


- (void)captureFinished{
    
    
    [self setDateForParticiationDeclinedOrFinished];

    _launcherViewController.view.hidden = true;

    
    [_window.rootViewController dismissViewControllerAnimated:true completion:^{
        
        [self remove];
        
    }];
    
    
    
    //Callback
    if ([self.delegate respondsToSelector:(@selector(captureFinished))]){
        [self.delegate captureFinished];
    }
}


- (void)applicationDidEnterBackground{
    
    
    //Only schedule a notification if consent has been given
    
    if (_consentGiven == true){
        
        
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            
            //Since the permission might be revoked at any time, we need to check this every time
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                
                //Create a local push notification
                
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = _notification.title;
                content.body = _notification.body;
                content.sound = [UNNotificationSound defaultSound];
                
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:_notification.timeout repeats:NO];
                
                NSString *identifier = kTALocalNotification;
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                      content:content trigger:trigger];
                
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    /*if (error != nil) {
                        NSLog(@"Something went wrong: %@",error);
                    }*/
                }];
                
                
            }
            
        }];
        
        
    }
    
}


- (void)didReceiveNotificationResponse:(UNNotificationResponse *_Nonnull)response{
    
    if ([response.notification.request.identifier isEqualToString:kTALocalNotification]){
        
        //Open the web view
        
        [self showWebViewControllerAnimated:false];
        
        
    }
    
}


#pragma mark - UNUserNotificationCenterDelegate


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    [self didReceiveNotificationResponse:response];
    
    completionHandler();
    
}

@end
