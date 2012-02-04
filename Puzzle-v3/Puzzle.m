//
//  Puzzle.m
//  Puzzle-v2
//
//  Created by xiag on 1/19/12.
//

#import "Puzzle.h"

@implementation Puzzle

@synthesize grid = _grid;
@synthesize fragments = _fragments;
@synthesize emptyPosition = _emptyPosition;

-(Puzzle*) initWithGrid:(Grid *)grid {
    self = [super init];
    if(self) {
        self.emptyPosition = CGPointMake(grid.horizontalLinesAmount-1, grid.verticalLinesAmount-1);
        self.grid = grid;
        self.fragments = [[[NSMutableArray alloc] init] autorelease];
        
        [self createFragments];
        [self shuffle];
    }
    return(self);
}

-(Puzzle*) initWithFragments:(NSMutableArray*)fragments {
    self = [super init];
    if(self) {
        
        
    }
    return(self);
}

-(void) createFragments {
    NSInteger counter = 1;
    
    for( int x=0; x<self.grid.horizontalLinesAmount; x++ ){
        for( int y=0; y<self.grid.verticalLinesAmount; y++ ) {
            CGPoint fragmentPosition = CGPointMake(x,y);
            
            // do not create fragment at empty position
            if(fragmentPosition.x == self.emptyPosition.x && fragmentPosition.y == self.emptyPosition.y) {
                continue;
            }
            
            Fragment *fragment = [[[Fragment alloc] initWithOriginalPosition:fragmentPosition] autorelease];
            fragment.number = counter;
            
            // add fragment to fragments array
            [self.fragments addObject:fragment];
            
            counter++;
        }
    }
}

-(void) shuffle {
    for (NSInteger i=0; i<2; i++) {
        [self moveFragment:[self randomFragment:[self fragmentsAvailableToMove]]];
    }
}

-(void) moveFragment:(Fragment*)fragment {
    NSInteger x = self.emptyPosition.x;
    NSInteger y = self.emptyPosition.y;
    
    self.emptyPosition = CGPointMake(fragment.currentPosition.x, fragment.currentPosition.y);
    
    fragment.currentPosition = CGPointMake(x,y);
}

-(Fragment*) randomFragment:(NSMutableArray*)fragments {
    NSInteger index = arc4random()%[fragments count];
    return [fragments objectAtIndex:index];
}

-(NSMutableArray*) fragmentsAvailableToMove {
    NSMutableArray *fragments = [[[NSMutableArray alloc] init] autorelease];
    
    // left
    Fragment *leftFragment = [self leftFragment:self.emptyPosition];
    if(nil != leftFragment) {
        [fragments addObject:leftFragment];
    }
    // right
    Fragment *rightFragment = [self rightFragment:self.emptyPosition];
    if(nil != rightFragment) {
        [fragments addObject:rightFragment];
    }
    // top
    Fragment *topFragment = [self topFragment:self.emptyPosition];
    if(nil != topFragment) {
        [fragments addObject:topFragment];
    }
    // bottom
    Fragment *bottomFragment = [self bottomFragment:self.emptyPosition];
    if(nil != bottomFragment) {
        [fragments addObject:bottomFragment];
    }
    
    return fragments;
}

-(BOOL) isPazzleAssembled {
    for (Fragment* fragment in self.fragments) {
        if(fragment.currentPosition.x != fragment.originalPosition.x || 
           fragment.currentPosition.y != fragment.originalPosition.y) {
            return NO;
        }
    }
    return YES;
}

-(BOOL) isFragmentAvailableToMove:(Fragment*)fragment {
    return YES;
}

-(Fragment*)leftFragment:(CGPoint)position {
    return [self fragmentAtPosition:CGPointMake(position.x - 1, position.y)];
}

-(Fragment*)rightFragment:(CGPoint)position {
    return [self fragmentAtPosition:CGPointMake(position.x + 1, position.y)];
}
-(Fragment*)topFragment:(CGPoint)position {
    return [self fragmentAtPosition:CGPointMake(position.x, position.y-1)];
}
-(Fragment*)bottomFragment:(CGPoint)position {
    return [self fragmentAtPosition:CGPointMake(position.x, position.y+1)];
}

-(Fragment *) fragmentAtPosition:(CGPoint) position {
    for (Fragment* fragment in self.fragments) {
        if(fragment.currentPosition.x == position.x && fragment.currentPosition.y == position.y) {
            return fragment;
        }
    }
    return nil;
}

@end
