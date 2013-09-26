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


@class Player;
@interface Game : CCScene
{
    CCLayerGradient *_skyLayer;
    InputLayer *_inputLayer;
    CGSize _winSize;
    NSDictionary *_configuration;
    Player *_player;
    ChipmunkSpace *_space;
    ccTime _accumulator;
    CCNode *_gameNode;
    CCParallaxNode *_parallaxNode;
    CGFloat _landscapeWidth;
}

@end
