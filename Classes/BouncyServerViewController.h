//
//  BouncyServerViewController.h
//  BouncyServer
//
//  Created by Andrew Pouliot on 11/18/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BouncyServer.h"

@interface BouncyServerViewController : UIViewController <BouncyServerDelegate> {
	BouncyServer *server;
	UILabel *outputLabel;
	UILabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *outputLabel;

@end

