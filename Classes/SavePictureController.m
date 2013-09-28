    //
//  SavePictureController.m
//  Steganography
//
//  Created by E Bagley on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavePictureController.h"


@implementation SavePictureController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(id) initWithImage:(UIImage*)image
{
	self = [super init];
	if (self == nil)
		return nil;
	
	[self setImage:image];
	
	return self;
}

@synthesize image = _image;

-(SavePictureView*) contentView
{
	return (SavePictureView*)[self view];
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	SavePictureView* savePictureView = [[SavePictureView alloc] initWithFrame:CGRectMake(10, 10, 300, 430) andImage:_image];
	[self setView:savePictureView];
	[savePictureView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self contentView] setDelegate:self];
}

-(void) viewTouched
{
	// create the action sheet
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Copy", nil];
	[actionSheet showInView:[self contentView]];
	[actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[[self contentView] saveImage];
	}
	if (buttonIndex == 1)
	{
		[[self contentView] copyImageToPasteboard:_image];
	}
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
    
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Memory error" message: @"Memory errror in SavePictureController.m" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[someError show];
	[someError release];

	
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[_image release];
}


@end
