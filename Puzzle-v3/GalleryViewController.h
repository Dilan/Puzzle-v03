//
//  GalleryViewController.h
//  Puzzle-v3
//
//  Created by xiag on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>
#import "ViewController.h"
#import "ImageGallery.h"

@interface GalleryViewController : UIViewController


@property (nonatomic,retain) NSMutableArray *images;
@property(copy) NSString *currentImagePath;
@property (retain, nonatomic) UIImage *puzzleScreenshot;
@property (retain, nonatomic) ViewController *onImageSelectHandler;

-(NSMutableArray*)readImageDirectory;
-(void) showImages;
-(NSString*) touchedImagePathAtPoint:(CGPoint)point;

@end
