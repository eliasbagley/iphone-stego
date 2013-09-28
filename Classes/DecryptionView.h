//
//  DecryptionView.h
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DecryptionDelegate
-(void) loadEncryptedButtonPressed;
-(void) revealImageButtonPressed;
@end


@interface DecryptionView : UIView 
{
	NSObject<DecryptionDelegate>* _delegate;
	UIButton* _loadEncryptedImageButton;
	UIButton* _decryptImageButton;
	UIImageView* _encryptedImageView;
}

@property(nonatomic, assign) NSObject<DecryptionDelegate>* delegate;
@property(nonatomic, readonly) UIButton* decryptImageButton;
@property(nonatomic, retain) UIImageView* encryptedImageView;

-(void) loadEncryptedButtonPressed;
-(void) revealImageButtonPressed;

@end
