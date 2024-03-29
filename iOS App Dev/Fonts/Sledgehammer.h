//
//  Sledgehammer.h
//  iOS App Dev
//
//  Created by Molly Twerk on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "cocos2d.h";
#import <Foundation/Foundation.h>

@interface Sledgehammer : CCPhysicsSprite
{
    ChipmunkSpace *_space;
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
@end
