//
//  SavePictureView.h
//  Steganography
//
//  Created by E Bagley on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol SavePictureViewProtocol
-(void)viewTouched;
@end

@interface SavePictureView : UIView 
{
	NSObject<SavePictureViewProtocol>* _delegate;
	UIImageView* _imageView;
}
@property(nonatomic, assign) NSObject<SavePictureViewProtocol>* delegate;

-(id) initWithFrame:(CGRect)frame andImage:(UIImage*)image;
-(void) saveImage;
-(void) copyImageToPasteboard:(UIImage*)image;

@end
