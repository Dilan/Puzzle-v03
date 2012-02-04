//
//  AppDelegate.h
//  Puzzle-v3
//
//  Created by xiag on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"
#import "Grid.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

-(Puzzle*)restorePuzzleState;
-(Puzzle*)createPuzzle;
-(NSString*)anyImagePath;

@end
