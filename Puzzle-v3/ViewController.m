//
//  ViewController.m
//  Puzzle-v3
//
//  Created by xiag on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GalleryViewController.h"

@implementation ViewController
{
    NSInteger secondsLeft;
    NSTimer *timer;
}

@synthesize imagePath = _imagePath;
@synthesize puzzle = _puzzle;
@synthesize tiles = _tiles;

@synthesize galleryViewController = _galleryViewController;

@synthesize motorEmitter;
@synthesize imageView;
@synthesize timerLabel;
@synthesize galleryButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1st
    [self sliceImageIntoTiles];
    // 2nd
    [self showPuzzle];
    // 3rd
    [self startTimer];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setTimerLabel:nil];
    [self setGalleryButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [imageView release];
    [timerLabel release];
    [galleryButton release];
    [self.galleryViewController release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
// application
// -----------------------------------------------------------------------------

-(void) stopTimer {
    secondsLeft = 0;
    [timer invalidate];
    timer = nil;
}

-(void) startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

-(void) updateCountdown {
    NSInteger hours;
    NSInteger minutes;
    NSInteger seconds;
    
    secondsLeft++;
    hours = secondsLeft / 3600;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft %3600) % 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}


-(void) reStartPuzzleWithImage:(NSString*)imagePath {
    self.timerLabel.text = @"00:00:00";
    [self stopTimer];
    [self startTimer];
    
    self.imagePath = imagePath;
    
    for (Tile* tile in self.tiles) {
        [tile.imageView removeFromSuperview];
    }
    
    [self.tiles removeAllObjects];
    
    
    [self.puzzle shuffle];
    [self.motorEmitter removeFromSuperlayer];
    
    [self sliceImageIntoTiles];
    [self showPuzzle];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self.imageView];
    
    // define touched fragment
    Fragment *fragment = [self fragmentAtPoint:currentTouchPoint];
    
    if (fragment.number>0 && YES == [self.puzzle isFragmentAvailableToMove:fragment]) {
        
        Tile *tile = [self tileAtPoint:currentTouchPoint];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];    
        
        CGPoint currentEmptyPosition = self.puzzle.emptyPosition;
        
        [self.puzzle moveFragment:fragment];
        
        tile.imageView.frame = [self tileFrameAtPosition:currentEmptyPosition];
        tile.currentPosition = currentEmptyPosition;
        
        
        if([self.puzzle isPazzleAssembled]) {
            [self showAssembledPuzzle];
        }
        
        [UIView commitAnimations];
    }
}

- (IBAction)showGallery:(id)sender {
    
    if(self.galleryViewController == nil) {
        GalleryViewController *galleryViewController = [[GalleryViewController alloc] initWithNibName:@"GalleryViewController" bundle:nil];
        self.galleryViewController = galleryViewController;
        [galleryViewController release];
    }
    
    
    self.galleryViewController.currentImagePath = self.imagePath;
    self.galleryViewController.puzzleScreenshot = [self subImageFrom:[self screenshot] WithRect:CGRectMake(20, 60, 285, 405)];
    
    self.galleryViewController.onImageSelectHandler = self;
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                           forView:self.view cache:NO];
    
    [self.galleryViewController viewWillAppear:YES];
    [self viewWillDisappear:YES];
    
    [self.view addSubview:self.galleryViewController.view];
    
    [self.galleryViewController viewDidAppear:YES];
    [self viewDidDisappear:YES];
    
    [UIView commitAnimations];
}

- (IBAction)hideGallery:(id)sender {
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft 
                           forView:self.view cache:NO];
    
    [self viewWillAppear:YES];
    [self.galleryViewController viewWillDisappear:YES];
    
    [self.galleryViewController.view removeFromSuperview];
    
    [self viewDidAppear:YES];
    [self.galleryViewController viewDidDisappear:YES];
    
    [UIView commitAnimations];
}



-(NSInteger) tileWidth
{
    return (int)(self.imageView.frame.size.width / self.puzzle.grid.horizontalLinesAmount);
}

-(NSInteger) tileHeight
{
    return (int)(self.imageView.frame.size.height / self.puzzle.grid.verticalLinesAmount);
}

-(CGRect) tileFrameAtPosition:(CGPoint)position {
    return CGRectMake(([self tileWidth]*position.x), ([self tileHeight]*position.y), [self tileWidth]-2, [self tileHeight]-2);
}

-(UIImageView*) tileViewAtPosition:(CGPoint)position {
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:self.imagePath];
    
    CGImageRef tileImageRef = CGImageCreateWithImageInRect(image.CGImage, [self tileFrameAtPosition:position]);
    UIImageView *tileView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:tileImageRef]];
    
    CGImageRelease(tileImageRef);
    
    tileView.frame = [self tileFrameAtPosition:position];
    
    [image release];
    
    return [tileView autorelease];
}

-(void) sliceImageIntoTiles {
    self.tiles = [[[NSMutableArray alloc] init] autorelease];
    
    NSInteger counter = 1;
    
    for( int x=0; x<self.puzzle.grid.horizontalLinesAmount; x++ ){
        for( int y=0; y<self.puzzle.grid.verticalLinesAmount; y++ ) {
            CGPoint tilePosition = CGPointMake(x,y);
            
            UIImageView *tileView = [self tileViewAtPosition:tilePosition];
            
            Tile *tile = [[[Tile alloc] initWithOriginalPosition:tilePosition AndImageView:tileView] autorelease];
            tile.number = counter;
            
            [self.tiles addObject:tile];
            
            counter++;
        }
    }
}

-(void) showPuzzle {
    for (Fragment* fragment in self.puzzle.fragments) {
        Tile *tile = [self findTileForOriginalPosition:fragment.originalPosition];
        // move Tile to corresponding position
        tile.imageView.frame = [self tileFrameAtPosition:fragment.currentPosition];
        tile.currentPosition = fragment.currentPosition;
        
        tile.imageView.layer.borderWidth = 1;
        tile.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.imageView addSubview:tile.imageView];
    }
}

-(Tile*) findTileForOriginalPosition:(CGPoint)position {
    for (Tile* tile in self.tiles) {
        if(tile.originalPosition.x == position.x && tile.originalPosition.y == position.y) {
            return tile;
        }
    }
    return nil;
}

-(void) showAssembledPuzzle {
    
    // 1 show last fragment
    Tile *tile = [self findTileForOriginalPosition:self.puzzle.emptyPosition];
    tile.imageView.layer.borderWidth = 1;
    tile.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.imageView addSubview:tile.imageView];
    
    for( Tile *tile in self.tiles ) {
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"]; 
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.duration = 1;
        [tile.imageView.layer addAnimation:animation forKey:@"whateverYouWant"];
        [CATransaction setCompletionBlock:^{
            tile.imageView.layer.borderWidth = 1;
        }];
        [CATransaction commit];
    }
    
    [self showFire];
    
    [self stopTimer];
}

-(CGImageRef)CGImageNamed:(NSString*)name {
    NSString* imageDirectoryPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"image"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:[imageDirectoryPath stringByAppendingPathComponent:name]];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, 32, 32));
    
    [image release];
    
    return imageRef;
}


-(void) showFire {
    
    //Load the spark image for the particle
	const char* fileName = [[[NSBundle mainBundle] pathForResource:@"tspark" ofType:@"png"] UTF8String];
    
	CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(fileName);
	id img = (id) CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
	
	mortor = [[CAEmitterLayer layer] retain];
	mortor.emitterPosition = CGPointMake(320, 0);
	mortor.renderMode = kCAEmitterLayerAdditive;
    
    
    //Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [[CAEmitterCell emitterCell] retain];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 400;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float fireColor[4] = {0.5, 0.5, 0.5, 0.5};
    CGColorRef color = CGColorCreate(colorSpace, fireColor);
    
	rocket.color = color;
	CGColorRelease(color);
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
	
	//Name the cell so that it can be animated later using keypath
	[rocket setName:@"rocket"];
	
	//Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = img;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
	
	//The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = img;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
	
	//Name the cell so that it can be animated later using keypath
	[firework setName:@"firework"];
	
	//preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
	//Name the cell so that it can be animated later using keypath
	[preSpark setName:@"preSpark"];
	
	//The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = img;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
    
	preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
	rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
	mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];
    
    self.motorEmitter = mortor;
    
    [[self.imageView layer] addSublayer:self.motorEmitter];
    
    /*
     
     
     //Create the fire emitter layer
     fireEmitter = [CAEmitterLayer layer];
     fireEmitter.emitterPosition = CGPointMake(265, 50);
     fireEmitter.emitterMode = kCAEmitterLayerOutline;
     fireEmitter.emitterShape = kCAEmitterLayerLine;
     fireEmitter.renderMode = kCAEmitterLayerAdditive;
     fireEmitter.emitterSize = CGSizeMake(0, 0);
     
     
     //Create the fire emitter cell
     CAEmitterCell* fire = [CAEmitterCell emitterCell];
     fire.emissionLongitude = M_PI;
     fire.birthRate = 0;
     fire.velocity = 80;
     fire.velocityRange = 30;
     fire.emissionRange = 1.1;
     fire.yAcceleration = 200;
     fire.scaleSpeed = 0.3;
     
     
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     float fireColor[4] = {0.8, 0.4, 0.2, 0.10};
     CGColorRef color = CGColorCreate(colorSpace, fireColor);
     
     fire.color = color;
     CGColorRelease(color);
     fire.contents = (id) [self CGImageNamed:@"image-fire.png"];
     
     //Name the cell so that it can be animated later using keypaths
     [fire setName:@"fire"];
     
     //Add the fire emitter cell to the fire emitter layer
     fireEmitter.emitterCells = [NSArray arrayWithObject:fire] ;
     
     
     //Query the gasSlider's value
     float gas = 0.5;
     
     //Update the fire properties
     [fireEmitter setValue:[NSNumber numberWithInt:(gas * 1000)] forKeyPath:@"emitterCells.fire.birthRate"];
     [fireEmitter setValue:[NSNumber numberWithFloat:gas] forKeyPath:@"emitterCells.fire.lifetime"];
     [fireEmitter setValue:[NSNumber numberWithFloat:(gas * 0.35)] forKeyPath:@"emitterCells.fire.lifetimeRange"];
     fireEmitter.emitterSize = CGSizeMake(50 * gas, 0);
     
     
     [[self.imageView layer] addSublayer:fireEmitter];
     
     */
    
    
	
    // float gas = 1;
	
	//Update the fire properties
    /*
	[fireEmitter setValue:[NSNumber numberWithInt:(gas * 1000)] forKeyPath:@"emitterCells.fire.birthRate"];
	[fireEmitter setValue:[NSNumber numberWithFloat:gas] forKeyPath:@"emitterCells.fire.lifetime"];
	[fireEmitter setValue:[NSNumber numberWithFloat:(gas * 0.35)] forKeyPath:@"emitterCells.fire.lifetimeRange"];
	fireEmitter.emitterSize = CGSizeMake(50 * gas, 0);
    */    
    
}

-(Tile *) tileAtPoint:(CGPoint) point {
    CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
    
    for( Tile *tile in self.tiles ) {
        if( CGRectIntersectsRect(tile.imageView.frame, touchRect) ){
            return tile;
        }
    }
    return nil;
}

-(Fragment *) fragmentAtPoint:(CGPoint) point {
    Tile *tile = [self tileAtPoint:point];
    
    if(tile.number) {
        return [self.puzzle fragmentAtPosition:tile.currentPosition];
    }
    return nil;
}

- (UIImage*)screenshot 
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// get sub image
- (UIImage*) subImageFrom: (UIImage*) img WithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image 
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

@end
