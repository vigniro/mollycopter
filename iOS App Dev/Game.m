//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "ChipmunkAutoGeometry.h"

@implementation Game

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        
        // Load configuration file
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        // Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Register collision handler
        //[_space setDefaultCollisionHandler:self
        //                             begin:@selector(collisionBegan:space:)
        //                          preSolve:nil
        //                            postSolve:nil
        //                          separate:nil];
        
        // Setup world
        [self setupGraphicsLandscape];
        [self setUpPhysicsLandscape];
        
        // Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = YES;
        [self addChild:debugNode];
        
        // Create a input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        // Add a tank
        NSString *playerPositionString = _configuration[@"playerPosition"];
        _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(playerPositionString)];
        [_gameNode addChild:_player];
        //[self addChild:_player];
        
        // Your initilization code goes here
        [self scheduleUpdate];
    }
    return self;
}

- (void)setupGraphicsLandscape
{
    _skyLayer = [CCLayerGradient layerWithColor:ccc4(89, 67, 245, 255) fadingTo:ccc4(255, 219, 245, 255)];
    [self addChild:_skyLayer];
    
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *mountains = [CCSprite spriteWithFile:@"BackgroundMountains.png"];
    mountains.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:mountains z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *floor = [CCSprite spriteWithFile:@"floor.png"];
    floor.anchorPoint = ccp(0, 0);
    //_floorWidth = floor.contentSize.width; // TODO : This is important, something something for the world.
    [_parallaxNode addChild:floor z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *ceiling = [CCSprite spriteWithFile:@"ceiling.png"];
    ceiling.anchorPoint = ccp(0, 0);
    //_ceilingWidth = ceiling.contentSize.width;
    [_parallaxNode addChild:ceiling z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    

}

- (void)setUpPhysicsLandscape
{
    //TODO Implement
//    NSLog(@"START: Setting up physics landscape.");
//    CCSprite* floor = [CCSprite spriteWithFile:@"floor.png"];
//    CGSize size = floor.textureRect.size;
//    ChipmunkBody *body = [ChipmunkBody staticBody];
//    body.pos = ccp(0, size.height);
//    ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
//    [_space addShape:shape];
//    NSLog(@"END: Setting up physics landscape.");
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"floor" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
    
    NSURL *ceilingUrl = [[NSBundle mainBundle] URLForResource:@"ceiling" withExtension:@"png"];
    ChipmunkImageSampler *ceilingSampler = [ChipmunkImageSampler samplerWithImageFile:ceilingUrl isMask:NO];
    
    ChipmunkPolylineSet *ceilingContour = [ceilingSampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *ceilingLine = [ceilingContour lineAtIndex:0];
    ChipmunkPolyline *ceilingSimpleLine = [ceilingLine simplifyCurves:1];
    
    ChipmunkBody *ceilingTerrainBody = [ChipmunkBody staticBody];
    NSArray *ceilingTerrainShapes = [ceilingSimpleLine asChipmunkSegmentsWithBody:ceilingTerrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in ceilingTerrainShapes)
    {
        [_space addShape:shape];
    }
}

- (void)touchStarted
{
    NSLog(@"Touch started.");
    //cpVect vector = cpv(0.0f, [_configuration[@"flyForce"] floatValue]);
    [_player flyWithForce];
}

- (void)touchEnded
{
    NSLog(@"No longer touching.");
    [_player removeForces];
}



- (void)update:(ccTime)delta
{
    // Update logic goes here
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    // TODO - Make 'camera' follow the player
    
    // Checking to see if the paralax effect works.
    //CGPoint backgroundScrollVel = ccp(-10, 0);
    //_parallaxNode.position = ccpAdd(_parallaxNode.position, ccpMult(backgroundScrollVel, delta));
    
}
@end


