//
//  Tile.m
//  Puzzle-v2
//
//  Created by xiag on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"

@implementation Tile

@synthesize number = _number;
@synthesize originalPosition = _originalPosition;
@synthesize currentPosition = _currentPosition;
@synthesize imageView = _imageView;

-(Tile*) initWithOriginalPosition:(CGPoint)originalPosition AndImageView:(UIImageView*)imageView {
    self = [super init];
    if(self) {
        self.originalPosition = originalPosition;
        self.currentPosition = originalPosition;
        self.imageView = imageView;
    }
    return(self);
}

@end
