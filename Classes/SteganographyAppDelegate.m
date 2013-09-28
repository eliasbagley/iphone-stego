//
//  SteganographyAppDelegate.m
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "SteganographyAppDelegate.h"

#pragma mark -
@implementation SteganographyAppDelegate

#pragma mark Constructors
- (void) applicationDidFinishLaunching:(UIApplication*)application 
{   
    //Create window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_mainScreenViewController = [[MainScreenViewController alloc] init];
	
	[_window setBackgroundColor:[UIColor purpleColor]];
	
	
	_navController = [[UINavigationController alloc] initWithRootViewController:_mainScreenViewController];
	_navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	_mainScreenViewController.title = @"Image Hider";
	
	[_window addSubview:[_navController view]];
	
    [_window makeKeyAndVisible];
}

- (void) applicationWillTerminate:(UIApplication*)application
{
    [_window release];
	[_navController release];
	[_mainScreenViewController release];
}

@end
