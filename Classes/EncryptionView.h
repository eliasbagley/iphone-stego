//
//  View.h
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol StegoImageDelegate
-(void) containerImageButtonPressed;
-(void) messageImageButtonPressed;
-(void) encryptMessageButtonPressed;
-(void) containerImageTapped;
-(void) messageImageTapped;
@end

@interface EncryptionView : UIView 
{
	NSObject<StegoImageDelegate>* _delegate;
	UIImageView* _containerImageView;
	UIImageView* _messageImageView;
}

@property(nonatomic, assign) NSObject<StegoImageDelegate>* delegate;

-(void) loadMessageImageButtonPressed;
-(void) loadContainerImageButtonPressed;
-(void) encryptMessageButtonPressed;

-(void) activateEncryptionButton;

-(void) setContainerImage:(UIImage *)image;
-(void) setMessageImage:(UIImage *)image;


@end
