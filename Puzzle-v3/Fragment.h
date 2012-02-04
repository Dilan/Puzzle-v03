//
//  Fragment.h
//  Puzzle-v2
//
//  Created by xiag on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fragment : NSObject

@property (nonatomic, readwrite) NSInteger number;
@property (nonatomic, readwrite) CGPoint originalPosition;
@property (nonatomic, readwrite) CGPoint currentPosition;

-(Fragment*) initWithOriginalPosition:(CGPoint)originalPosition;

@end
