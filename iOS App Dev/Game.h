//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "InputLayer.h"
#import "HudLayer.h"


@class Player;
@class Goal;


@interface Game : CCScene <InputLayerDelegate>
{
    CCLayerGradient *_skyLayer;
    InputLayer *_inputLayer;
    CGSize _winSize;
    NSDictionary *_configuration;
    Player *_player;
    Goal *_goal;
    ChipmunkSpace *_space;
    ccTime _accumulator;
    CCParticleSystemQuad *_splashParticles;
    CCNode *_gameNode;
    CCParallaxNode *_parallaxNode;
    CGFloat _landscapeWidth;
    BOOL _playerFollow;
    HudLayer *_hudLayer;
}

@end
