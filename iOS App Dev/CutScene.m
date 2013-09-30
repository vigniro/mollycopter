//
//  CutScene.m
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "CutScene.h"

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
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play video" fontName:@"Marker Felt" fontSize:64];
        CCMenuItemLabel *labelItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(testCCVideoPlayer)];
        
        CCMenu *menu = [CCMenu menuWithItems:labelItem, nil];
        [menu alignItemsHorizontally];
        [self addChild:menu];
        
        [CCVideoPlayer setDelegate: self];
    }
    return self;
}

- (void) testCCVideoPlayer
{
    [CCVideoPlayer playMovieWithFile:@"bollywood.mp4"];
}

- (void) moviePlaybackFinished {
    [[CCDirector sharedDirector] startAnimation];
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
