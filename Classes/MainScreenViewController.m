    //
//  MainScreenViewController.m
//  Steganography
//
//  Created by E Bagley on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainScreenViewController.h"


@implementation MainScreenViewController

-(MainView*) contentView
{
	return (MainView*)[self view];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	MainView* mainView = [[MainView alloc] initWithFrame:CGRectMake(10, 10, 300, 430)];
	[self setView:mainView];
	[mainView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self contentView] setDelegate:self];
	//[self.navigationController setNavigationBarHidden:TRUE animated:YES];
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
    
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Memory error" message: @"Memory error in MainScreenViewController.m" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
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
}

-(void) encrypt
{
	EncryptionController* encryptionController = [[EncryptionController alloc] init];
	[self.navigationController pushViewController:encryptionController animated:YES];
	[encryptionController release];
}

-(void) decrypt
{
	DecryptionController* decryptionController = [[DecryptionController alloc] init];
	[self.navigationController pushViewController:decryptionController animated:YES];
	[decryptionController release];
}

@end
