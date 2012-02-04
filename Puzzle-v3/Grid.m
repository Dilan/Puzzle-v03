//
//  Grid.m
//  Puzzle-v2
//
//  Created by xiag on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Grid.h"

@implementation Grid

@synthesize horizontalLinesAmount = _horizontalLinesAmount;
@synthesize verticalLinesAmount = _verticalLinesAmount;

-(Grid*) initWithHorizontalLinesAmount:(NSInteger)horizontalLinesAmount AndVerticalLinesAmount:(NSInteger)verticalLinesAmount {
    self = [super init];
    if(self) {
        self.horizontalLinesAmount = horizontalLinesAmount;
        self.verticalLinesAmount = verticalLinesAmount;
    }
    return(self);
}

@end