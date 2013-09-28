//
//  MainView.h
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MainScreenDelegate
-(void) encrypt;
-(void) decrypt;
@end


@interface MainView : UIView 
{
	NSObject<MainScreenDelegate>* _delegate;
	//UIButton* _encryptButton;
	//UIButton* _decryptButton;
}

@property(nonatomic, assign) NSObject<MainScreenDelegate>* delegate;

-(void) encryptButtonPressed;
-(void) decryptButtonPressed;

@end
