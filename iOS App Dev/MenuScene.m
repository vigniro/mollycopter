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
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"START\n MOLLYCOPTER" fontName:@"Arial" fontSize:40];
        CCMenuItemLabel *button = [CCMenuItemLabel itemWithLabel:label block:^(id sender)
        {
            Game *gameScene = [[Game alloc] init];
            [[CCDirector sharedDirector] replaceScene:gameScene];
        }];
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        button.position = ccp(size.width/2, size.height/2);
        
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

@end
