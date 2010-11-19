//
//  BouncyServer.m
//  BouncyServer
//
//  Created by Andrew Pouliot on 11/18/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import "BouncyServer.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation BouncyServer

@synthesize numberOfClients;
@synthesize delegate;
@synthesize port;

- (id)init;
{
	self = [super init];
	if (!self) return nil;	
	
	//Provide a default port if none specified
	port = 12302;
	serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
	
	return self;
}


- (NSString *)currentIPAddress
{
	NSString *address = nil;
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				//TODO: this could be handled a lot more elegantly!!
#if TARGET_IPHONE_SIMULATOR
				// Check if interface is en1 which is the wifi connection on the mac
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"])
#else
					// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
#endif
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}


- (void)startListening;
{
	NSLog(@"Listening on port: %d", port);
	NSError *error = nil;
	if (![serverSocket acceptOnPort:port error:&error]) {
		NSLog(@"Listen error: %@", error);
	} else {
		[delegate serverStartedOnAddress:[self currentIPAddress] port:[serverSocket localPort]];
	}
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
	[newSocket retain];

	NSData *dat = [@"Welcome. Send me a message\r\n" dataUsingEncoding:NSASCIIStringEncoding];
	[newSocket writeData:dat withTimeout:20.0 tag:-1];
	
	//Time out in 3 mins
	[newSocket readDataToData:[AsyncSocket LFData] withTimeout:60.0 * 3 maxLength:144 tag:1];
	
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{
	numberOfClients++;
		
	[delegate serverClientsChanged:self];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
{
	numberOfClients--;
	[delegate serverClientsChanged:self];
	[sock release];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	[delegate server:self recievedMessage:string];
	
	//Time out in 3 mins
	[sock readDataToData:[AsyncSocket LFData] withTimeout:60.0 * 3 maxLength:144 tag:1];
}

- (void)dealloc
{
	[serverSocket release];


	[super dealloc];
}


@end
