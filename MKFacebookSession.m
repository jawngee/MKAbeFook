//
//  MKFacebookSession.m
//  MKAbeFook
//
//  Created by Mike Kinney on 9/19/09.
//  Copyright 2009 Mike Kinney. All rights reserved.
//
/*
 Copyright (c) 2009, Mike Kinney
 All rights reserved.
 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 Neither the name of MKAbeFook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "MKFacebookSession.h"

NSString *MKFacebookSessionKey = @"MKFacebookSession";

@implementation MKFacebookSession

@synthesize session;
@synthesize apiKey;
@synthesize secretKey;

SYNTHESIZE_SINGLETON_FOR_CLASS(MKFacebookSession);

- (id)init{
	self = [super init];
	if(self != nil)
	{
		session = nil;
	}
	return self;
}

- (void)saveSession:(NSDictionary *)aSession{
	//TODO: check for a valid session before saving
	
	if(aSession != nil)
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:aSession forKey:MKFacebookSessionKey];
		self.session = aSession;
	}
}

- (BOOL)loadSession{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *savedSession = [defaults objectForKey:MKFacebookSessionKey];
	//TODO: check for valid session before returning yes
	if(savedSession != nil)
	{
		self.session = savedSession;
		return YES;
	}else {
		self.session = nil;
		return NO;
	}
}

- (BOOL)validSession{
	if([[NSUserDefaults standardUserDefaults] objectForKey:MKFacebookSessionKey] != nil)
		return YES;
	return NO;
}

- (void)destroySession{
	DLog(@"session was destroyed");
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:MKFacebookSessionKey];
	self.session = nil;
}

- (NSString *)sessionKey{
	return [self.session valueForKey:@"session_key"];
}

- (NSString *)sessionSecret{
	return [self.session valueForKey:@"secret"];
}

- (NSString *)expirationDate{
	return [self.session valueForKey:@"expires"];
}

- (NSString *)uid{
	return [self.session valueForKey:@"uid"];
}

- (NSString *)sig{
	return [self.session valueForKey:@"sig"];
}


- (void)dealoc{
	[session release];
	[apiKey release];
	[secretKey release];
	[super dealloc];
}

@end