//
//  SavePictureView.m
//  Steganography
//
//  Created by E Bagley on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavePictureView.h"




@implementation SavePictureView


- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image 
{
    
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 430)];
	[_imageView setImage:image];

	[self addSubview:_imageView];
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_delegate viewTouched];
}

- (void)dealloc 
{
    [super dealloc];
	[_imageView release];
}

-(void) saveImage
{
	NSData* data = UIImagePNGRepresentation(_imageView.image);
	ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
    //__block NSDate *date = [[NSDate date] retain];
    [al writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
       // NSLog(@"Saving Time: %g", [[NSDate date] timeIntervalSinceDate:date]);
        //[date release];
    }];
    [al release];
}

-(void) copyImageToPasteboard:(UIImage*)image
{
	UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
	[pasteboard setImage:image];
}
@end
