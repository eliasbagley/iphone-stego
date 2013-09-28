    //
//  DecryptionController.m
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DecryptionController.h"
#define numSteps 8

@implementation DecryptionController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

-(id) init
{
	self = [super init];
	if (self == nil)
		return nil;
	
	_imagePicker = [[UIImagePickerController alloc] init];
	[_imagePicker setDelegate:self];
	[_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
	[_activityIndicator setCenter:CGPointMake(160.0f, 220.0f)];
	[_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
    return self;
}


@synthesize encryptedImage = _encryptedImage;
@synthesize decryptedImage = _decryptedImage;

-(DecryptionView*) contentView
{
	return (DecryptionView*)[self view];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	DecryptionView* decryptionView = [[DecryptionView alloc] initWithFrame:CGRectMake(10, 10, 300, 430)];
	[self setView:decryptionView];
	[decryptionView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	[[self contentView] setDelegate:self];
	[[self contentView] addSubview:_activityIndicator];
	self.title = @"Revealer";
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Memory error" message: @"Memory errror in DecryptionController.m" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[someError show];
	[someError release];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
	[_imagePicker release];
	[_encryptedImage release];
	[_decryptedImage release];
	[_activityIndicator release];
}

-(void) loadEncryptedButtonPressed
{
	[self presentModalViewController:_imagePicker animated:YES];
}

-(void) decodeImage
{
	// create an autorelease pool for this thread
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	
	// error checking: make sure that both container and message aren't null, and that they are the same size
	if (_encryptedImage == nil)
		NSAssert(FALSE, @"Encrypted image shouln't be nil when decoding");
	
	CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB(); // create the RGB color space
	/*
	 * Note we specify 4 bytes per pixel here even though we ignore the
	 * alpha value; you can't specify 3 bytes per-pixel.
	 */
	size_t d_bytesPerRow = _encryptedImage.size.width * 4;
	int length = _encryptedImage.size.height*d_bytesPerRow;
	
	unsigned char* imgData = (unsigned char*)malloc(length);
	
	CGContextRef context =  CGBitmapContextCreate(imgData, _encryptedImage.size.width, _encryptedImage.size.height, 8, d_bytesPerRow, d_colorSpace, kCGImageAlphaNoneSkipFirst);
	
	
	UIGraphicsPushContext(context);
	// These next two lines 'flip' the drawing so it doesn't appear upside-down.
	CGContextTranslateCTM(context, 0.0, _encryptedImage.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	// Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
	[_encryptedImage drawInRect:CGRectMake(0.0, 0.0, _encryptedImage.size.width, _encryptedImage.size.height)];
	UIGraphicsPopContext();
	
	/*
	 * At this point, we have the raw ARGB pixel data in the imgData buffer, so
	 * we can perform whatever image processing here.
	 */
	
	int stepSize = 255/(numSteps-1);
	
	for (int i = 0; i < length; i++)
	{
		imgData[i] = stepSize*(imgData[i]%numSteps);
		
	}
	
	// After we've processed the raw data, turn it back into a UIImage instance.
	CGImageRef new_img = CGBitmapContextCreateImage(context);
	UIImage * convertedImage = [[[UIImage alloc] initWithCGImage:new_img] autorelease];
	
	CGImageRelease(new_img);
	CGContextRelease(context);
	CGColorSpaceRelease(d_colorSpace);
	free(imgData);
	[self setDecryptedImage:convertedImage];
	[_activityIndicator stopAnimating];
	
	SavePictureController* savePictureController = [[SavePictureController alloc] initWithImage:_decryptedImage];
	[self.navigationController pushViewController:savePictureController animated:YES];
	[savePictureController release];
	
	// release the pool
	[pool release];
	
}

-(void) revealImageButtonPressed 
{
	[_activityIndicator startAnimating];
	[NSThread detachNewThreadSelector:@selector(decodeImage) toTarget:self withObject:nil];
	
}



-(void) imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*) image editingInfo:(NSDictionary*)editingInfo
{
	[self setEncryptedImage:image]; 
	[[[self contentView] encryptedImageView] setHidden:FALSE];
	[[[self contentView] encryptedImageView] setImage:image];
	[[[self contentView] decryptImageButton] setHidden:FALSE];
	[self dismissModalViewControllerAnimated:TRUE];
}

@end
