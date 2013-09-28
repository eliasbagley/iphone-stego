//
//  MainScreenViewController.h
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainView.h"
#import "DecryptionController.h"
#import "EncryptionController.h"

@interface MainScreenViewController : UIViewController<MainScreenDelegate, UINavigationControllerDelegate>
{
}

-(void) encrypt;
-(void) decrypt;
@end
