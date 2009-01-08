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
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
	_frontView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_frontView setBackgroundColor:[UIColor whiteColor]];
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectMake(0, bounds.size.height / 10, bounds.size.width, 20);
	_text = [[UILabel alloc] initWithFrame:rect];
	[_text setTextAlignment:UITextAlignmentCenter];
	_text.text = @"Hello Mobile MKAbeFook.";
	[_frontView addSubview:_text];


	
	
	_loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_loginButton.frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight); //kStdButtonWidth and kStdButtonHeight are copied from the apple UIShowcase application, they are defined in MMKFacebook.h
	_loginButton.backgroundColor = [UIColor clearColor];
	[_loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[_loginButton addTarget:self action:@selector(showLogin) forControlEvents:UIControlEventTouchUpInside];
	_loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	_loginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_loginButton.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height /2);
	[_frontView addSubview:_loginButton];

	[self.window addSubview:_frontView];
	
	
	_facebookConnection = [[MMKFacebook facebookWithAPIKey:@"2c05304285010949050742956e95db9a" 
												withSecret:@"c656ff9157b2d9d93c2c72cf9607044b" 
												  delegate:self] retain];
	
	 [window makeKeyAndVisible];

	 
}

-(void)showLogin
{
	//simulator wipes out preferences after each build
	if([_facebookConnection loadPersistentSession] == NO)
		[_facebookConnection showFacebookLoginWindow];
}

-(void)userLoginSuccessful
{
	[_loginButton removeFromSuperview];
	_text.text = @"Mobile MKAbeFook is ready for use. :)";
	
	UIButton *loadUserInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	loadUserInfo.frame = CGRectMake(0.0, 0.0, kStdButtonWidth, kStdButtonHeight);
	[loadUserInfo setTitle:@"Get User Info" forState:UIControlStateNormal];
	[loadUserInfo addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventTouchUpInside];
	loadUserInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	loadUserInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	loadUserInfo.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 4);
	[_frontView addSubview:loadUserInfo];
	
	UIImageView *testPictureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testPicture.png"]];
	testPictureView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height -200);
	[_frontView addSubview:testPictureView];
	[testPictureView release];

	UIButton *uploadPiratePicture = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	uploadPiratePicture.frame = CGRectMake(0.0, 0.0, kStdButtonWidth * 2, kStdButtonHeight);
	[uploadPiratePicture setTitle:@"Upload Pirate Picture" forState:UIControlStateNormal];
	[uploadPiratePicture addTarget:self action:@selector(uploadPiratePicture) forControlEvents:UIControlEventTouchUpInside];
	loadUserInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	uploadPiratePicture.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	uploadPiratePicture.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height -100);
	[_frontView addSubview:uploadPiratePicture];
	

	UIButton *grantExtendedPermissions = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	grantExtendedPermissions.frame = CGRectMake(0.0, 0.0, kStdButtonWidth * 2, kStdButtonHeight);
	[grantExtendedPermissions setTitle:@"Grant Offline Permisison" forState:UIControlStateNormal];
	[grantExtendedPermissions addTarget:self action:@selector(grantExtendedPermissions) forControlEvents:UIControlEventTouchUpInside];
	grantExtendedPermissions.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	grantExtendedPermissions.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	grantExtendedPermissions.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height -50);
	[_frontView addSubview:grantExtendedPermissions];
	
}

-(void)returningUserToApplication
{
	NSLog(@"returning to app");
}

-(void)getUserInfo
{
	MMKFacebookRequest *request = [[[MMKFacebookRequest alloc] init] autorelease];
	[request setDelegate:self];
	[request setFacebookConnection:_facebookConnection];
	
	//display loading sheet
	[request displayLoadingSheet:YES];

	[request setSelector:@selector(gotUserInfo:)];
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setValue:@"facebook.users.getInfo" forKey:@"method"];
	[parameters setValue:[_facebookConnection uid] forKey:@"uids"];
	[parameters setValue:@"name" forKey:@"fields"];
	[request setParameters:parameters];
	[request sendRequest];
	[parameters release];
}

-(void)uploadPiratePicture
{
	MMKFacebookRequest *request = [[[MMKFacebookRequest alloc] init] autorelease];
	[request setDelegate:self];
	[request setFacebookConnection:_facebookConnection];
	
	//display loading sheet
	[request displayLoadingSheet:YES];
	
	[request setSelector:@selector(uploadedPicture:)];
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setValue:@"facebook.photos.upload" forKey:@"method"];
	//[parameters setValue:@"126349408045409169" forKey:@"aid"];
	[parameters setValue:@"pirate flag" forKey:@"caption"];
	[parameters setValue:[UIImage imageNamed:@"testPicture.png"] forKey:@"picture"];
	[request setParameters:parameters];
	[request sendRequest];
	[parameters release];
	
}

-(void)grantExtendedPermissions
{
	[_facebookConnection grantExtendedPermission:@"offline_access"];
}
-(UIView *)applicationView
{
	return _frontView;
}



-(void)facebookResponseReceived:(CXMLDocument *)xml
{
	NSLog([[[xml rootElement] arrayFromXMLElement] description]);

}

-(void)uploadedPicture:(CXMLDocument *)xml
{
	_text.text = @"Picture uploaded, visit site to verify";
}

-(void)gotUserInfo:(CXMLDocument *)xml
{
	//NSLog([[[xml rootElement] arrayFromXMLElement] description]);
	_text.text = [NSString stringWithFormat:@"Hello %@", [[[xml rootElement] dictionaryFromXMLElement] valueForKey:@"name"]];
}

- (void)dealloc {

	[window release];
	[super dealloc];
}

@end