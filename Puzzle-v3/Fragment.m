//
//  Fragment.m
//  Puzzle-v2
//
//  Created by xiag on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Fragment.h"

@implementation Fragment

@synthesize number = _number;
@synthesize originalPosition = _originalPosition;
@synthesize currentPosition = _currentPosition;

-(Fragment*) initWithOriginalPosition:(CGPoint)originalPosition {
    self = [super init];
    if(self) {
        self.originalPosition = originalPosition;
        self.currentPosition = originalPosition;
    }
    return(self);
}

@end
