//
//  Grid.h
//  Puzzle-v2
//
//  Created by xiag on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

@property (nonatomic, readwrite) NSInteger horizontalLinesAmount;
@property (nonatomic, readwrite) NSInteger verticalLinesAmount;

-(Grid*) initWithHorizontalLinesAmount:(NSInteger)horizontalLinesAmount AndVerticalLinesAmount:(NSInteger)verticalLinesAmount;

@end