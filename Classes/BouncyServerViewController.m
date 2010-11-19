//
//  BouncyServerViewController.m
//  BouncyServer
//
//  Created by Andrew Pouliot on 11/18/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import "BouncyServerViewController.h"

//Our server code
#import "BouncyServer.h"

//For Animation
#import <QuartzCore/QuartzCore.h>
#import "AccelerationAnimation.h"
#import "Evaluate.h"

@implementation BouncyServerViewController

@synthesize infoLabel;
@synthesize outputLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) return nil;
	
	server = [[BouncyServer alloc] init];
	server.delegate = self;
	
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return self; 

	server = [[BouncyServer alloc] init];
	server.delegate = self;

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	long seed = time(NULL);
	srandom(seed);
	
	float hue = (float)random()/RAND_MAX;
	
	//Set background color randomly
	self.view.backgroundColor = [UIColor colorWithHue:hue
										   saturation:1.0f
										   brightness:0.8f
												alpha:1.0f];
	
	[server startListening];
}

- (void)doBouncy;
{
	SecondOrderResponseEvaluator *evaluator = [[[SecondOrderResponseEvaluator alloc] initWithOmega:80.0 zeta:0.2] autorelease];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:3.0] forKey:kCATransactionAnimationDuration];
	
	CATransform3D start = CATransform3DMakeScale(0.0001, 0.0001, 1);
	
	AccelerationAnimation *animation =
	[AccelerationAnimation
	 animationWithKeyPath:@"transform"
	 startTransform:start
	 endTransform:CATransform3DIdentity
	 timeOffset:0.01
	 evaluationObject:evaluator
	 interstitialSteps:100];
	
	
	//[animation setDelegate:self];
	//[self.vi setValue:[NSNumber numberWithDouble:[self maxYPoint].y] forKeyPath:@"position.y"];
	[self.outputLabel.layer addAnimation:animation forKey:@"position"];
	[CATransaction commit];
	
}


#pragma mark -

- (void)serverStartedOnAddress:(NSString *)address port:(UInt16)port;
{
	outputLabel.text = @"Started";
	infoLabel.text = [NSString stringWithFormat:@"telnet %@ %d", address, (int)port];
}

- (void)serverClientsChanged:(BouncyServer *)inServer;
{
	outputLabel.text = @"Clients changed";
}

- (void)server:(BouncyServer *)inServer recievedMessage:(NSString *)inMessage;
{
	outputLabel.text = inMessage;
	[self doBouncy];
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
	return YES;
}


- (void)viewDidUnload {
	self.outputLabel = nil;
}


- (void)dealloc {
	[outputLabel release];
	outputLabel = nil;

	[infoLabel release];
	infoLabel = nil;

    [super dealloc];
}

@end
