//
//  DecryptionController.h
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecryptionView.h"
#import "SavePictureController.h"

@interface DecryptionController : UIViewController<DecryptionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	UIImage* _encryptedImage;
	UIImage* _decryptedImage;
	UIImagePickerController* _imagePicker;
	UIActivityIndicatorView* _activityIndicator;
}

@property(nonatomic, retain) UIImage* encryptedImage;
@property(nonatomic, retain) UIImage* decryptedImage;

-(void) loadEncryptedButtonPressed;
-(void) revealImageButtonPressed;
@end
