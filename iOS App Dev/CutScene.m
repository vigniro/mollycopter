//
//  CutScene.m
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
//  Credits to SUPERSURACCOON tutorial

#import "CutScene.h"
#import "Game.h"
#import "MenuScene.h"

@implementation CutScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CutScene *layer = [CutScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        [CCVideoPlayer playMovieWithFile:@"mollycopter-final-2.mp4"];
        [CCVideoPlayer setDelegate: self];
        
    }
    return self;
}

- (void) testCCVideoPlayer
{
    [CCVideoPlayer playMovieWithFile:@"mollycopter.mp4"];
}

- (void) switchScene {
    Game *gameScene = [[Game alloc] init];
    [[CCDirector sharedDirector] replaceScene:gameScene];
    
    /*MenuScene *menuScene = [[MenuScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:menuScene];*/
}

- (void) moviePlaybackFinished {
    [[CCDirector sharedDirector] startAnimation];
    
    [self performSelector:@selector(switchScene)];
}

- (void) movieStartsPlaying {
    [[CCDirector sharedDirector] stopAnimation];
}

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

- (void) updateOrientationWithOrientation: (UIDeviceOrientation) newOrientation {
    [CCVideoPlayer updateOrientationWithOrientation:newOrientation];
}

#endif

- (void) dealloc {
    [super dealloc];
}

@end
