//
//  Coin.m
//  iOS App Dev
//
//  Created by Molly Twerk on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Coin.h"

@implementation Coin
- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"mileyBall.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            //_configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
            
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
@end
