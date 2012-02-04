//
//  Tile.h
//  Puzzle-v2
//
//  Created by xiag on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject

@property (nonatomic, readwrite) NSInteger number;
@property (nonatomic, readwrite) CGPoint originalPosition;
@property (nonatomic, readwrite) CGPoint currentPosition;
@property (retain, nonatomic) UIImageView *imageView;

-(Tile*) initWithOriginalPosition:(CGPoint)originalPosition AndImageView:(UIImageView*)imageView;

@end
