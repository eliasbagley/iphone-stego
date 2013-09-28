//
//  View.m
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EncryptionView.h"


@implementation EncryptionView

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	UIButton* containerImagePickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[containerImagePickerButton setFrame:CGRectMake(40, 20, 240, 50)];
	[containerImagePickerButton setTitle:@"Load Cover Image" forState:UIControlStateNormal];
	[containerImagePickerButton addTarget:self action:@selector(loadContainerImageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton* messageImagePickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[messageImagePickerButton setFrame:CGRectMake(40, 80, 240, 50)];
	[messageImagePickerButton setTitle:@"Load Secret Image" forState:UIControlStateNormal];
	[messageImagePickerButton addTarget:self action:@selector(loadMessageImageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	_containerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 135, 100, 150)];
	[_containerImageView setHidden:TRUE];
	
	_messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 135, 100, 150)];
	[_messageImageView setHidden:TRUE];
	
	[self addSubview:_containerImageView];
	[self addSubview:_messageImageView];
	[self addSubview:containerImagePickerButton];
	[self addSubview:messageImagePickerButton];
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[_containerImageView release];
	[_messageImageView release];
}

@synthesize delegate = _delegate;

-(void) setContainerImage:(UIImage*) image
{
	[_containerImageView setImage:image];
	[_containerImageView setHidden:FALSE];
}
-(void) setMessageImage:(UIImage*) image
{
	[_messageImageView setImage:image];
	[_messageImageView setHidden:FALSE];
}

-(void) loadMessageImageButtonPressed
{
	[_delegate messageImageButtonPressed];
}
-(void) loadContainerImageButtonPressed
{
	[_delegate containerImageButtonPressed];
}

-(void) encryptMessageButtonPressed
{
	[_delegate encryptMessageButtonPressed];
}

-(void) activateEncryptionButton
{
	UIButton* encryptMessageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[encryptMessageButton setFrame:CGRectMake(20, 360, 280, 50)];
	[encryptMessageButton setTitle:@"Hide Secret Image Inside Cover Image" forState:UIControlStateNormal];
	[encryptMessageButton addTarget:self action:@selector(encryptMessageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:encryptMessageButton];
	
}

-(void) touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event
{
	
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	if (CGRectContainsPoint([_containerImageView frame], touchPoint) && ![_containerImageView isHidden])
	{
		[_delegate containerImageTapped];
	}
	else if (CGRectContainsPoint([_messageImageView frame], touchPoint) && ![_messageImageView isHidden])
	{
		[_delegate messageImageTapped];
	}
}

@end
