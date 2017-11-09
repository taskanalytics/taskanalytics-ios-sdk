//
//  TaskAnalytics.h
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 20.09.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UserNotifications;

//! Project version number for TaskAnalytics.
FOUNDATION_EXPORT double TaskAnalyticsVersionNumber;

//! Project version string for TaskAnalytics.
FOUNDATION_EXPORT const unsigned char TaskAnalyticsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TaskAnalytics/PublicHeader.h>


@protocol TaskAnalyticsDelegate<NSObject>

@optional -(void)consentButtonPressed;
@optional -(void)closeButtonPressed;
@optional -(void)launcherButtonPressed;
@optional -(void)consentAccepted;
@optional -(void)consentDeclined;
@optional -(void)captureFinished;
@optional -(void)captureDestroy;

@end

typedef NS_ENUM(NSInteger, TACorner) {
    TACornerTopLeft,
    TACornerTopRight,
    TACornerBottomLeft,
    TACornerBottomRight,
};

typedef NS_ENUM(NSInteger, TAEdge) {
    TAEdgeTop,
    TAEdgeBottom
};

@interface TaskAnalytics: NSObject<TaskAnalyticsDelegate, UNUserNotificationCenterDelegate>

+ (instancetype _Nonnull)sharedInstance;

@property (nonatomic, weak) id <TaskAnalyticsDelegate> _Nullable delegate;



/**
 For debug purposes, you might want to provide a custom server URL.
 */
@property (nonatomic, strong) NSURL* _Nullable serverURL;


/**
 Sets up the Task Analytyics SDK

 @param ID Your Task Analytics ID
 */
- (void)setupWithID:(nonnull NSString*)ID;


/**
 The consent button spans the full width of the screen. It can be placed in a vertical distance from the top or bottom edge.
 
 If you run this method after the consent button is displayed, it will animate into the new position. This way, can you move it if it obstructs important content in your app.

 @param verticalDistance Number of points from top or bottom edge.
 @param edge Top or bottom.
 */
- (void)setConsentButtonVerticalDistance:(float)verticalDistance fromEdge:(TAEdge)edge;


/**
 The launcher button is a round button showing your avatar. It can be placed a certain number of points on the horizontal and vertical distance from one of the four screen corners.
 
 If you run this method after the launcher button is displayed, it will animate into the new position. This way, can you move it if it obstructs important content in your app.
 
 @param horizontalDistance Number of horizontal points from the corner.
 @param verticalDistance Number of vertical points from the corner.
 @param corner Corner where the launcher button should be displayed.
 */
- (void)setLauncherButtonHorizontalDistance:(float)horizontalDistance verticalDistance:(float)verticalDistance fromCorner:(TACorner)corner;



/**
 When you're ready to show Task Analytics, run this method.
 Whether or not the Task Analytics will be displayed will be determined by the server.
 */
- (void)show;


/**
 Hides Task Analytics
 
 If you have views in your app where you don't want to show Task Analytics, you can hide it using this method.
 */
- (void)hide;



/**
 For debug purposes, you might want to reset all settings.
 */
- (void)reset;

/**
 If the user does not finish answering the capture form, a local push notification can be triggered, nudging the user to complete. This can either be done by setting Task Analytics to be the UNUserNotificationCenterDelegate
 
 ```UNUserNotificationCenter.currentNotificationCenter.delegate = TaskAnalytics.sharedInstance;```

 or, by forwarding the notification response to this method.

 @param response The UNNotificationResponse received.
 */
- (void)didReceiveNotificationResponse:(UNNotificationResponse *_Nonnull)response;
@end

