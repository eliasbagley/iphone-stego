//
//  Controller.m
//  Steganography
//
//  Created by E Bagley on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EncryptionController.h"

#define numSteps 8 // 255 cannot be divisible by this number, and I think 255 mod x has to equal x-1

@implementation EncryptionController

-(id) init
{
	self = [super init];
	if (self == nil)
		return nil;
	
	_imagePicker = [[UIImagePickerController alloc] init];
	[_imagePicker setDelegate:self];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
	[_activityIndicator setCenter:CGPointMake(160.0f,220.0f)];
	[_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	[self setContainerImageFlag:TRUE];   // initialize it to true, just assume that the first image they pick is the container
	
	return self;
}

@synthesize containerImage = _containerImage;
@synthesize messageImage = _messageImage;
@synthesize containerImageFlag = _containerImageFlag;


-(EncryptionView*) contentView
{
	return (EncryptionView*)[self view];
}

-(void) loadView
{
	EncryptionView* screenView = [[EncryptionView alloc] initWithFrame:CGRectMake(10, 10, 300, 430)];
	[self setView:screenView];
	[screenView release];
}
-(void) viewDidLoad
{
	[super viewDidLoad];
	[[self contentView] setDelegate:self];
	[[self contentView] addSubview:_activityIndicator];
	self.title = @"Hider";
}
- (void)actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger numberOfButtons = [actionSheet numberOfButtons];
	if (numberOfButtons == 3) // this device has a camera
	{
		if (buttonIndex == 0)
		{
			[_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			[self presentModalViewController:_imagePicker animated:YES];
		}
		else if (buttonIndex == 1)
		{	
			[_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
			[self presentModalViewController:_imagePicker animated:YES];
		}
	}
	else // no camera on this device
	{
		if (buttonIndex == 0)
		{
			[_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			[self presentModalViewController:_imagePicker animated:YES];
		}
	}

	
}	

-(void) containerImageButtonPressed
{
	[self setContainerImageFlag:TRUE];
	
	UIActionSheet* actionSheet;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Cover Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album", @"Camera", nil];
	}
	else 
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Cover Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album", nil];
	}

	[actionSheet showInView:[self contentView]];
	[actionSheet release];
	
}
-(void) messageImageButtonPressed
{
	[self setContainerImageFlag:FALSE]; // so that we know which picture corresponds to the message, and which corresponds to the container
	
	UIActionSheet* actionSheet;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Secret Message Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album", @"Camera", nil];
	}
	else 
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Secret Message Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album", nil];
	}
	
	[actionSheet showInView:[self contentView]];
	[actionSheet release];
}

-(void) encryptMessageButtonPressed
{
	[_activityIndicator startAnimating];
	[NSThread detachNewThreadSelector:@selector(encodeImage) toTarget:self withObject:nil];  // create a new thread so that the indicator can animate
}


-(void) imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*) image editingInfo:(NSDictionary*)editingInfo
{
	if (_containerImageFlag)
	{
		[self setContainerImage:image];
		[[self contentView] setContainerImage:image];
	}
	else 
	{
		[self setMessageImage:image];
		[[self contentView] setMessageImage:image];
	}
	
	// if both images are non nil at this point, then we can activate the encryption button
	if (_containerImage != nil && _messageImage != nil)
	{
		[[self contentView] activateEncryptionButton];
	}
	
	[self dismissModalViewControllerAnimated:TRUE];
}

-(void) encodeImage 
{
	// create an autorelease pool for this thread
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	
    /*
     * Note we specify 4 bytes per pixel here even though we ignore the
     * alpha value; you can't specify 3 bytes per-pixel.
     */
    size_t d_bytesPerRowContainer = _containerImage.size.width * 4; // bytes per row is the number of pixels in the width, times 4, since there are RGBA
	size_t d_bytesPerRowMessage = _messageImage.size.width * 4;
	
	// message image must be smaller in both dimensions
	if (d_bytesPerRowMessage > d_bytesPerRowContainer || _messageImage.size.height > _containerImage.size.height)
	{
		UIAlertView* error = [[UIAlertView alloc] initWithTitle: @"Container Image Too Small!" message: @"Container image must be larger than the message image in both the width and the height. Please load a different container image." delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[error show];
		[error release];
		[_activityIndicator stopAnimating];
		return;
	}
	
	 CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// size of the entire byte stream is the number of pixels in the height, multiplied by the number of bytes in each row
	int lengthContainer = _containerImage.size.height*d_bytesPerRowContainer; 
	int lengthMessage = _messageImage.size.height*d_bytesPerRowMessage;
	
	//int minLength = MIN(lengthContainer, lengthMessage);
	
	// section off a block of memory for each of the byte streams
    unsigned char* imgDataContainer = (unsigned char*)malloc(lengthContainer);
	unsigned char* imgDataMessage = (unsigned char*)malloc(lengthMessage);
	
    CGContextRef contextContainer =  CGBitmapContextCreate(imgDataContainer, _containerImage.size.width, _containerImage.size.height, 8, d_bytesPerRowContainer, d_colorSpace, kCGImageAlphaNoneSkipFirst);
	CGContextRef contextMessage =  CGBitmapContextCreate(imgDataMessage, _messageImage.size.width, _messageImage.size.height, 8, d_bytesPerRowMessage, d_colorSpace, kCGImageAlphaNoneSkipFirst);
    
	UIGraphicsPushContext(contextContainer);
    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
    CGContextTranslateCTM(contextContainer, 0.0, _containerImage.size.height);
    CGContextScaleCTM(contextContainer, 1.0, -1.0);
    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
    [_containerImage drawInRect:CGRectMake(0.0, 0.0, _containerImage.size.width, _containerImage.size.height)];
    UIGraphicsPopContext();
	
	UIGraphicsPushContext(contextMessage);
    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
    CGContextTranslateCTM(contextMessage, 0.0, _messageImage.size.height);
    CGContextScaleCTM(contextMessage, 1.0, -1.0);
    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
    [_messageImage drawInRect:CGRectMake(0.0, 0.0, _messageImage.size.width, _messageImage.size.height)];
    UIGraphicsPopContext();
    /*
     * At this point, we have the raw ARGB pixel data in the imgData buffer, so
     * we can perform whatever image processing here.
     */
	for(int i = 0; i < lengthContainer; i++)
	{
		imgDataContainer[i] = imgDataContainer[i] - imgDataContainer[i]%numSteps;

	}
	// at this point, all values are divisible by numSteps
	
	float stepSize = 255.0/numSteps;
	
	for (int i = 0; i < _messageImage.size.height; i++)
	{
		for (int j = 0; j < d_bytesPerRowMessage; j++)
		{
			int offset = imgDataMessage[d_bytesPerRowMessage*i+j]/stepSize;
			offset = offset%numSteps;
			imgDataContainer[d_bytesPerRowContainer*i+j] +=  offset;
		}
	}
	
    // After we've processed the raw data, turn it back into a UIImage instance.
    CGImageRef new_img = CGBitmapContextCreateImage(contextContainer);
    UIImage * convertedImage = [[[UIImage alloc] initWithCGImage:new_img] autorelease];
	
    CGImageRelease(new_img);
    CGContextRelease(contextContainer);
	CGContextRelease(contextMessage);
    CGColorSpaceRelease(d_colorSpace);
    free(imgDataContainer);
	free(imgDataMessage);
	
	//[self setEncryptedImage:convertedImage];
	[_activityIndicator stopAnimating];
	
	SavePictureController* savePictureController = [[SavePictureController alloc] initWithImage:convertedImage]; // immediately push the converted image
	[self.navigationController pushViewController:savePictureController animated:YES];
	[savePictureController release];
	
	// release the pool
	[pool release];
}

-(void) containerImageTapped
{
	SavePictureController* imgViewController = [[SavePictureController alloc] initWithImage:_containerImage];
	[self.navigationController pushViewController:imgViewController animated:YES];
	[imgViewController release];
}
-(void) messageImageTapped
{
	SavePictureController* imgViewController = [[SavePictureController alloc] initWithImage:_messageImage];
	[self.navigationController pushViewController:imgViewController animated:YES];
	[imgViewController release];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Memory error" message: @"Memory error in EncryptionController.m" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[someError show];
	[someError release];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
	[super dealloc];
	[_containerImage release];
	[_messageImage release];
	[_imagePicker release];
	[_activityIndicator release];
	
}


@end
