//
//  MainView.m
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"


@implementation MainView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self == nil)
		return nil;
	
	UIButton* _encryptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_encryptButton setFrame:CGRectMake(60, 20, 200, 180)];
	[_encryptButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
	[_encryptButton setTitle:@"Hide an Image" forState:UIControlStateNormal];
	[_encryptButton addTarget:self action:@selector(encryptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton* _decryptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_decryptButton setFrame:CGRectMake(60, 210, 200, 180)];
	[_decryptButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
	[_decryptButton setTitle:@"Reveal an Image" forState:UIControlStateNormal];
	[_decryptButton addTarget:self action:@selector(decryptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:_encryptButton];
	[self addSubview:_decryptButton];
	
	
    return self;
}

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
	_delegate = nil;
}

-(void) encryptButtonPressed
{
	NSLog(@"encrypt button pressed");
	[_delegate encrypt];
}
-(void) decryptButtonPressed
{
	[_delegate decrypt];
}

@end
