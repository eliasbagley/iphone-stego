//
//  SteganographyAppDelegate.h
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EncryptionController.h"
#import "MainScreenViewController.h"

//@class Controller, MainScreenViewController;

@interface SteganographyAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow* _window;
	
	UINavigationController* _navController;
	MainScreenViewController* _mainScreenViewController;
}

@end

