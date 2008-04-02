//
//  Mobile_MKAbeFookAppDelegate.m
//  Mobile MKAbeFook
//
//  Created by Mike Kinney on 3/28/08.
//  Copyright Mike Kinney 2008. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "Mobile_MKAbeFookAppDelegate.h"
#import "MMKFacebookRequest.h"
#import "CXMLDocument.h"
#import "CXMLDocumentAdditions.h"
#import "CXMLElementAdditions.h"

@implementation Mobile_MKAbeFookAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Create window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
	_frontView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_frontView setBackgroundColor:[UIColor whiteColor]];
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectMake(0, bounds.size.height / 5, bounds.size.width, 20);
	
	_text = [[UILabel alloc] initWithFrame:rect];
	[_text setTextAlignment:UITextAlignmentCenter];
	_text.text = @"Hello Mobile MKAbeFook.";
	[_frontView addSubview:_text];

	
	
	
	_loginButton = [UIButton buttonWithType:UIButtonTypeNavigation];
	[_loginButton setTitle:@"Login" forStates:UIControlStateNormal];
	[_loginButton addTarget:self action:@selector(showLogin) forControlEvents:UIControlEventTouchUpInside];
	_loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	_loginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_loginButton.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height /2);
	[_frontView addSubview:_loginButton];

	[self.window addSubview:_frontView];
	
	// Show window
	[window makeKeyAndVisible];
	
	_facebookConnection = [[MMKFacebook facebookWithAPIKey:@"2c05304285010949050742956e95db9a" 
												withSecret:@"c656ff9157b2d9d93c2c72cf9607044b" 
												  delegate:self] retain];
	//_facebookConnection = [[MMKFacebook facebookWithAPIKey:@"2c1db9a" withSecret:@"1" delegate:self] retain];

	UIButton *loadUserInfo = [UIButton buttonWithType:UIButtonTypeNavigation];
	[loadUserInfo setTitle:@"Get User Info" forStates:UIControlStateNormal];
	[loadUserInfo addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventTouchUpInside];
	loadUserInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	loadUserInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	loadUserInfo.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height /3);
	[_frontView addSubview:loadUserInfo];	
	
}

-(void)showLogin
{
	[_facebookConnection showFacebookLoginWindow];
}

-(void)userLoginSuccessful
{
	[_loginButton removeFromSuperview];
	_text.text = @"Mobile MKAbeFook is ready for use. :)";
	

	
}

-(void)getUserInfo
{
	MMKFacebookRequest *request = [[[MMKFacebookRequest alloc] init] autorelease];
	[request setDelegate:self];
	[request setFacebookConnection:_facebookConnection];
	[request displayLoadingSheet:YES];

	
	UIView *blue = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[blue setBackgroundColor:[UIColor blueColor]];
	[request displayLoadingWithView: nil 
					 transitionType:kCATransitionFade
				  transitionSubtype:kCATransitionFromLeft
						   duration:0.5];
	
	[request setSelector:@selector(facebookResponseReceived:)];
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setValue:@"facebook.users.getInfo" forKey:@"method"];
	[request setParameters:parameters];
	[request sendRequest];
	[parameters release];
}

-(UIView *)frontView
{
	return _frontView;
}


-(void)facebookResponseReceived:(CXMLDocument *)xml
{
	NSLog([[[xml rootElement] arrayFromXMLElement] description]);
	NSLog([[_frontView subviews] description]);
}


- (void)dealloc {

	[window release];
	[super dealloc];
}

@end
