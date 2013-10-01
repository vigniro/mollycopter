//
//  Sledgehammer.m
//  iOS App Dev
//
//  Created by Molly Twerk on 10/1/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Sledgehammer.h"

@implementation Sledgehammer
- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"sledgehammer.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            CGSize size = self.textureRect.size;
            
            ChipmunkBody *body = [ChipmunkBody staticBody];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
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
