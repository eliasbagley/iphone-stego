//
//  DecryptionView.m
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DecryptionView.h"


@implementation DecryptionView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self == nil)
		return nil;
	
	_loadEncryptedImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_loadEncryptedImageButton setFrame:CGRectMake(40, 20, 240, 50)];
	[_loadEncryptedImageButton setTitle:@"Load Encrypted Image" forState:UIControlStateNormal];
	[_loadEncryptedImageButton addTarget:self action:@selector(loadEncryptedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	_decryptImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_decryptImageButton setFrame:CGRectMake(40, 80, 240, 50)];
	[_decryptImageButton setTitle:@"Reveal Image" forState:UIControlStateNormal];
	[_decryptImageButton addTarget:self action:@selector(revealImageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[_decryptImageButton setHidden:TRUE];
	
	_encryptedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 140, 200, 260)];
	[_encryptedImageView setHidden:TRUE];
	
	[self addSubview:_loadEncryptedImageButton];
	[self addSubview:_decryptImageButton];
	[self addSubview:_encryptedImageView];
	
    return self;
}

@synthesize decryptImageButton = _decryptImageButton;
@synthesize encryptedImageView = _encryptedImageView;
@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc 
{
    [super dealloc];
	//[_loadEncryptedImageButton release];
	//[_decryptImageButton release];
	[_encryptedImageView release];
}

-(void) loadEncryptedButtonPressed
{
	[_delegate loadEncryptedButtonPressed];
}

-(void) revealImageButtonPressed
{
	[_delegate revealImageButtonPressed];
}


@end
