//
//  MenuScene.m
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "MenuScene.h"
#import "cocos2d.h"
#import "Game.h"

@implementation MenuScene

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"START" fontName:@"Arial" fontSize:48];
        CCMenuItemLabel *button = [CCMenuItemLabel itemWithLabel:label block:^(id sender)
        {
            Game *gameScene = [[Game alloc] init];
            [[CCDirector sharedDirector] replaceScene:gameScene];
        }];
        button.position = ccp(200, 200);
        
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

@end
