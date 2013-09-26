//
//  Player.h
//  iOS App Dev
//
//  Created by Molly Twerk on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCPhysicsSprite
{
    ChipmunkSpace *_space;
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
- (void)flyWithPower:(CGFloat)power vector:(cpVect)vector;

@end
