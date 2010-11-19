//
//  BouncyServer.h
//  BouncyServer
//
//  Created by Andrew Pouliot on 11/18/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"

@protocol BouncyServerDelegate;

@interface BouncyServer : NSObject {
	UInt16 port;
	
	NSInteger numberOfClients;
	id <BouncyServerDelegate> delegate;
	
	AsyncSocket *serverSocket;
}

@property (nonatomic, readonly) NSInteger numberOfClients;
@property (nonatomic, assign) id<BouncyServerDelegate> delegate;
@property (nonatomic, assign) UInt16 port;

- (void)startListening;

@end


@protocol BouncyServerDelegate

- (void)serverStartedOnAddress:(NSString *)address port:(UInt16)port;
- (void)serverClientsChanged:(BouncyServer *)inServer;
- (void)server:(BouncyServer *)inServer recievedMessage:(NSString *)inMessage;

@end