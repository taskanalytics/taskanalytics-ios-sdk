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
@property (nonatomic, strong) NSURL* _Nullable serverURL;

- (void)setupWithID:(nonnull NSString*)ID;
- (void)setConsentButtonVerticalDistance:(float)verticalDistance fromEdge:(TAEdge)edge;
- (void)setLauncherButtonHorizontalDistance:(float)horizontalDistance verticalDistance:(float)verticalDistance fromCorner:(TACorner)corner;
- (void)show;
- (void)hide;
- (void)reset;

- (void)didReceiveNotificationResponse:(UNNotificationResponse *_Nonnull)response;
@end

