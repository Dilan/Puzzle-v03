//
//  ViewController.h
//  Puzzle-v3
//
//  Created by xiag on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>
#import "Puzzle.h"
#import "Tile.h"
#import "ImageGallery.h"

@class GalleryViewController;

@interface ViewController : UIViewController {
    CAEmitterLayer *fireEmitter;
    CAEmitterLayer *mortor;
}

@property (retain, nonatomic) CAEmitterLayer *motorEmitter;

@property (nonatomic, retain) GalleryViewController *galleryViewController;

@property (retain, nonatomic) IBOutlet UIView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UIButton *galleryButton;

- (IBAction)showGallery:(id)sender;
- (IBAction)hideGallery:(id)sender;

@property(strong, nonatomic) Puzzle *puzzle;

@property(copy) NSString *imagePath;
@property (nonatomic,retain) NSMutableArray *tiles;

-(CGImageRef)CGImageNamed:(NSString*)name;
-(void) sliceImageIntoTiles;
-(void) showPuzzle;
-(void) showFire;
-(void) showAssembledPuzzle;
-(NSInteger) tileWidth;
-(NSInteger) tileHeight;
-(UIImageView*) tileViewAtPosition:(CGPoint)position;
-(CGRect) tileFrameAtPosition:(CGPoint)position;

-(Tile*) findTileForOriginalPosition:(CGPoint)position;
-(Tile *) tileAtPoint:(CGPoint) point;

-(Fragment *) fragmentAtPoint:(CGPoint) point;

-(void) reStartPuzzleWithImage:(NSString*)imagePath;

- (UIImage*)screenshot;
- (UIImage*) subImageFrom: (UIImage*) img WithRect: (CGRect) rect;

-(void) startTimer;
-(void) stopTimer;


@end
