//
//  BouncyServerAppDelegate.h
//  BouncyServer
//
//  Created by Andrew Pouliot on 11/18/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BouncyServerViewController;

@interface BouncyServerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BouncyServerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BouncyServerViewController *viewController;

@end

