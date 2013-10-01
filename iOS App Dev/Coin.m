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
    self = [super initWithFile:@"mdmagold-30.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {            
            CGSize size = self.textureRect.size;
            
            ChipmunkBody *body = [ChipmunkBody staticBody];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:size.width/2 offset:cpv(0,0)];
            shape.sensor = YES;

            // Add to space
            [_space addShape: shape];
            
            // Add to pysics sprite
            body.data = self;
            self.chipmunkBody = body;
        }
    }
    return self;
}
@end
