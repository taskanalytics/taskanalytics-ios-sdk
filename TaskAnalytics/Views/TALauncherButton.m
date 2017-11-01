//
//  TALauncherButton.m
//  TaskAnalytics
//
//  Created by Andreas Schjønhaug on 10.10.2017.
//  Copyright © 2017 Task Analytics AS. All rights reserved.
//

#import "TALauncherButton.h"

@implementation TALauncherButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds = false;

        //Shadow
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        self.layer.shadowOpacity = 0.32;
        
        //Border
        self.layer.borderColor = [UIColor.blackColor colorWithAlphaComponent:0.05].CGColor;
        self.layer.borderWidth = 0.5;
        
    }
    return self;
}



@end
