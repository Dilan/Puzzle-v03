//
//  Puzzle.h
//  Puzzle-v2
//
//  Created by xiag on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fragment.h"
#import "Grid.h"

@interface Puzzle : NSObject

@property (nonatomic,retain) NSMutableArray *fragments;
@property (nonatomic,retain) Grid *grid;
@property (nonatomic, readwrite) CGPoint emptyPosition;

-(Puzzle*) initWithGrid:(Grid*)grid;
-(Puzzle*) initWithFragments:(NSMutableArray*)fragments;
-(void) createFragments;
-(void) shuffle;

-(void) moveFragment:(Fragment*)fragment;

-(NSMutableArray*) fragmentsAvailableToMove;
-(BOOL) isFragmentAvailableToMove:(Fragment*)fragment;

-(Fragment*) randomFragment:(NSMutableArray*)fragments;
-(BOOL) isPazzleAssembled;
-(Fragment *) fragmentAtPosition:(CGPoint) position;

-(Fragment*)leftFragment:(CGPoint)position;
-(Fragment*)rightFragment:(CGPoint)position;
-(Fragment*)topFragment:(CGPoint)position;
-(Fragment*)bottomFragment:(CGPoint)position;

@end
