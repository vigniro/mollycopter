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
    NSDictionary *_configuration;
    CGFloat _flyforce;
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
- (void)flyWithForce;
- (void)flyWithImpulse:(CGFloat)power vector:(cpVect)vector;
- (void)removeForces;

//@property (nonatomic, strong) CGFloat flyForce;§§


@end
