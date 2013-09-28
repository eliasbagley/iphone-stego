//
//  SavePictureController.h
//  Steganography
//
//  Created by E Bagley on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavePictureView.h"

@interface SavePictureController : UIViewController<SavePictureViewProtocol, UIActionSheetDelegate>
{
	UIImage* _image;
}

@property(nonatomic, retain) UIImage* image;

@end
