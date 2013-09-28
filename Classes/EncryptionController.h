//
//  Controller.h
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncryptionView.h"
#import "SavePictureController.h"

@interface EncryptionController : UIViewController<StegoImageDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
	UIImage* _containerImage;
	UIImage* _messageImage;
	
	UIImagePickerController* _imagePicker;
	UIActivityIndicatorView* _activityIndicator;
	
	BOOL _containerImageFlag;
}

@property(nonatomic, retain) UIImage* containerImage;
@property(nonatomic, retain) UIImage* messageImage;
@property(nonatomic, assign) BOOL containerImageFlag;

-(id) init;
-(void) containerImageButtonPressed;
-(void) messageImageButtonPressed;
-(void) encryptMessageButtonPressed;
-(void) imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*) image editingInfo:(NSDictionary*)editingInfo;
-(void) encodeImage;

@end
