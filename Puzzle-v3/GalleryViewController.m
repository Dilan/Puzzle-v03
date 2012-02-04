//
//  GalleryViewController.m
//  Puzzle-v3
//
//  Created by xiag on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"

@implementation GalleryViewController

@synthesize currentImagePath = _currentImagePath;
@synthesize puzzleScreenshot = _puzzleScreenshot;
@synthesize onImageSelectHandler = _onImageSelectHandler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showImages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// -----------------------------------------------------------------------------
// application
// -----------------------------------------------------------------------------

-(NSString*)imageDirectoryPath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"image"];
}

- (NSMutableArray*)readImageDirectory
{    
    NSString *path = [self imageDirectoryPath];
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    for (NSString *fileName in [[NSFileManager defaultManager] enumeratorAtPath:path]) {
        [files addObject:[path stringByAppendingPathComponent:fileName]];
    }
    return [files autorelease];
}

-(void)showImages {
    NSMutableArray *files = [self readImageDirectory];
    
    NSInteger counter = 0;
    for (UIImageView *imageView in [[self view] subviews]) {
        NSString *filePath = [files objectAtIndex:counter]; 
        if(nil != filePath) {
            if([filePath isEqualToString:self.currentImagePath]) {
                imageView.image = self.puzzleScreenshot;
            } else {
                imageView.image = [[[UIImage alloc] initWithContentsOfFile:filePath] autorelease];
            }
            imageView.layer.borderWidth = 1;
        }
        counter++;
    }
}

-(NSString*) touchedImagePathAtPoint:(CGPoint)point {
    CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
    
    NSInteger counter = 0;
    for (UIImageView *imageView in [[self view] subviews]) {
        if( CGRectIntersectsRect(imageView.frame, touchRect) ) {
            return [[self readImageDirectory] objectAtIndex:counter];        
        }
        counter++;
    }
    return nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    NSString *touchedImagePath = [self touchedImagePathAtPoint:point];
    
    if(nil != touchedImagePath) {
        
        if(![touchedImagePath isEqualToString:self.currentImagePath]) {
            [self.onImageSelectHandler reStartPuzzleWithImage:touchedImagePath];
        }
        
        [self.onImageSelectHandler hideGallery:self];
    }
}

@end
