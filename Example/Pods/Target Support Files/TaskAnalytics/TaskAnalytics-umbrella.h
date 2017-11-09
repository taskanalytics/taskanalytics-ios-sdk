#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TACapture.h"
#import "TAConsent.h"
#import "TAConstants.h"
#import "TANotification.h"
#import "TAUtils.h"
#import "TACaptureWebViewController.h"
#import "TAConsentViewController.h"
#import "TALauncherViewController.h"
#import "TaskAnalytics.h"
#import "TAConsentButton.h"
#import "TALauncherButton.h"

FOUNDATION_EXPORT double TaskAnalyticsVersionNumber;
FOUNDATION_EXPORT const unsigned char TaskAnalyticsVersionString[];

