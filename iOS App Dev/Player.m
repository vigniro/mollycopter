//
//  Player.m
//  iOS App Dev
//
//  Created by Molly Twerk on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "InputLayer.h"
#import "ChipmunkAutoGeometry.h"
#import "Goal.h"
#import "SimpleAudioEngine.h"


@implementation Player
- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"mileyBall.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
            //_flyForce = [_configuration[@"flyForce" ] floatValue];

            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat moment = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
            
            // Add to space
            [_space addBody:body];
            [_space addShape:shape];
            
            // Add to pysics sprite
            self.chipmunkBody = body;
            
            // Apply a constant lateral force to make the player move to the right.
            //cpVect forceVector = cpvmult(ccp(0,1), 100000);
            //[self.chipmunkBody applyForce:forceVector offset:cpvzero];
        }
    }
    return self;
}


- (void)flyWithForce
{
    cpVect forceVector = cpvmult(ccp(0,1), self.chipmunkBody.mass * [_configuration[@"flyForce"] floatValue]);
    [self.chipmunkBody applyForce:forceVector offset:cpvzero];
}


- (void)removeForces
{
    //NSLog(@"Force before reset: %@",NSStringFromCGPoint(self.chipmunkBody.body->f));
    self.chipmunkBody.body->f.y = 0;
    //NSLog(@"Force after reset: %@",NSStringFromCGPoint(self.chipmunkBody.body->f));
}

- (void)flyWithImpulse:(CGFloat)power vector:(cpVect)vector;
{
    cpVect impulseVector = cpvmult(vector, power);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

@end


