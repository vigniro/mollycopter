//
//  HudLayer.m
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "HudLayer.h"

@implementation HudLayer

- (id)initWithConfiguration:(NSDictionary *)configuration
{
    self = [super init];
    if (self != nil)
    {
        CCLabelTTF *score = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"MENU" fontName:@"Arial" fontSize:16] block:^(id sender)
                                       {
                                           [[CCDirector sharedDirector] popScene];
                                       }];
        score.position = CGPointFromString(configuration[@"menuButtonPosition"]);
        
        CCMenu *menu = [CCMenu menuWithItems:score, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

@end
