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
#import "HUDLayer.h"


@class Player;
@class Goal;
@class Coin;


@interface Game : CCScene <InputLayerDelegate>
{
    int score;
    CCLabelTTF *scoreLabel;
    HUDLayer * _hud;
    
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
    BOOL _gameOver;
    Coin *_coin;
    NSMutableArray *_coinArray;
    NSMutableArray *_hammerArray;
}

+ (id)scene;

@end
