//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "Coin.h"
#import "Sledgehammer.h"
#import "ChipmunkAutoGeometry.h"
#import "Goal.h"
#import "SimpleAudioEngine.h"
#import "HUDLayer.h"

@implementation Game

+ (id)scene {
    CCScene *scene = [CCScene node];
    
    Game *layer = [Game node];
    [scene addChild: layer];
    
    return scene;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _hud = [[HUDLayer alloc] init];
        [self addChild:_hud z:1];
        
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        
        // Load configuration file
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        // Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Register collision handler
        [_space setDefaultCollisionHandler:self
                                     begin:@selector(collisionBegan:space:)
                                  preSolve:nil
                                    postSolve:nil
                                  separate:nil];
        
        // Setup world
        [self setupGraphicsLandscape];
        [self setUpPhysicsLandscape];
        
        // Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = NO;
        [self addChild:debugNode];
        
        // Add goal
        _goal = [[Goal alloc] initWithSpace:_space position:CGPointFromString(_configuration[@"goalPosition"])];
        [_gameNode addChild:_goal];
        
        //Set the score to zero.
        score = 0;
        distanceScore = 0;
        
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = ccp(30, 290);
        [self addChild:scoreLabel z:1];
        
        // Create a input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        // Setup particle system
        _splashParticles = [CCParticleSystemQuad particleWithFile:@"WaterSplash.plist"];
        _splashParticles.position = _goal.position;
        [_splashParticles stopSystem];
        [_gameNode addChild:_splashParticles];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"sledgehammer.mp3"];
        
        // Add a player
        NSString *playerPositionString = _configuration[@"playerPosition"];
        _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(playerPositionString)];
        [_gameNode addChild:_player];
        cpVect forceVector = cpvmult(ccp(1,0), [_configuration[@"playerLateralForce"] floatValue]);
        [_player.chipmunkBody applyForce:forceVector offset:cpvzero];
        
        _playerFollow = YES;
        _gameOver = NO;
        
        [self createCoins];
        [self createHammers];
        
        
        // Your initilization code goes here
        [self scheduleUpdate];
    }
    return self;
}

- (void)addPoint:(int)points
{
    score += points;
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score+distanceScore]];
}

- (void)deductPoint:(int)points
{
    score -= points;
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score+distanceScore]];
}

- (bool)collisionBegan:(cpArbiter *)arbiter space:(ChipmunkSpace*)space {
    cpBody *firstBody;
    cpBody *secondBody;
    Coin *removeCoin;
    Sledgehammer *removeHammer;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    
    ChipmunkBody *firstChipmunkBody = firstBody->data;
    ChipmunkBody *secondChipmunkBody = secondBody->data;
    [self deductPoint:30];
    
    if ((firstChipmunkBody == _player.chipmunkBody && secondChipmunkBody == _goal.chipmunkBody) ||
        (firstChipmunkBody == _goal.chipmunkBody && secondChipmunkBody == _player.chipmunkBody)){
        NSLog(@"PLayer finished game.");
        [self addPoint:1000];
        
        
        // Play sfx
        [[SimpleAudioEngine sharedEngine] playEffect:@"sledgehammer.mp3"];
        
        // Remove physics body
        [_space smartRemove:_player.chipmunkBody];
        for (ChipmunkShape *shape in _player.chipmunkBody.shapes) {
            [_space smartRemove:shape];
        }
        
        // Remove player from cocos2d
        [_player removeFromParentAndCleanup:YES];
        
        // Play particle effect
        [_splashParticles resetSystem];
        
        _gameOver = YES;
        [_hud showRestartMenu];
    }
    
    
    for(Coin *coin in _coinArray){
        if ((firstChipmunkBody == _player.chipmunkBody && secondChipmunkBody == coin.chipmunkBody) ||
            (firstChipmunkBody == coin.chipmunkBody && secondChipmunkBody == _player.chipmunkBody)){
            NSLog(@"Collected coin.");
            [self addPoint:250];
            
            // Play sfx
            [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
            
            // Remove physics body
            //[_space smartRemove:_coin.chipmunkBody];
            for (ChipmunkShape *shape in coin.chipmunkBody.shapes) {
                [_space smartRemove:shape];
            }
            
            // Remove coin from cocos2d
            [coin removeFromParentAndCleanup:YES];
            
            removeCoin = coin;
        }
    }
    
    
    for(Sledgehammer *hammer in _hammerArray){
        if ((firstChipmunkBody == _player.chipmunkBody && secondChipmunkBody == hammer.chipmunkBody) ||
            (firstChipmunkBody == hammer.chipmunkBody && secondChipmunkBody == _player.chipmunkBody)){
            NSLog(@"Crashed into a hammer.");
            //[self addPoint:100];
            
            // Play sfx
            [[SimpleAudioEngine sharedEngine] playEffect:@"sledgehammer.mp3"];
            
            // Remove physics body
            //[_space smartRemove:_coin.chipmunkBody];
            for (ChipmunkShape *shape in hammer.chipmunkBody.shapes) {
                [_space smartRemove:shape];
                
            }
            
            cpVect impulseVector = cpvsub(_player.position, hammer.position);
            cpVect normalisedVector = cpvnormalize(impulseVector);
            [_player flyWithImpulse:[_configuration[@"hammerImpulse"] floatValue] vector:normalisedVector];
            
            // Remove coin from cocos2d
            [hammer removeFromParentAndCleanup:YES];
            
            removeHammer = hammer;
            
            // Play particle effect
            _splashParticles.position = hammer.position;
            [_splashParticles resetSystem];
        }
    }
    
    [_coinArray removeObject:removeCoin];
    [_hammerArray removeObject:removeHammer];

    return YES;
}

- (void)setupGraphicsLandscape
{
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *skylayer = [CCSprite spriteWithFile:@"skylayerClean2.png"];
    skylayer.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:skylayer z:0 parallaxRatio:ccp(0.0f, 0.0f) positionOffset:CGPointZero];
    
    CCSprite *moon = [CCSprite spriteWithFile:@"fullmoonsingle.png"];
    moon.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:moon z:1 parallaxRatio:ccp(0.05f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *skyline = [CCSprite spriteWithFile:@"skylineSilhouette.png"];
    skyline.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:skyline z:2 parallaxRatio:ccp(0.2f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *brickWall = [CCSprite spriteWithFile:@"brickWall.png"];
    brickWall.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:brickWall z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *floor = [CCSprite spriteWithFile:@"floor.png"];
    floor.anchorPoint = ccp(0, 0);
    _landscapeWidth = floor.contentSize.width; // TODO : This is important, something something for the world.
    [_parallaxNode addChild:floor z:4 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *ceiling = [CCSprite spriteWithFile:@"ceiling.png"];
    ceiling.anchorPoint = ccp(0, 0);
    //_ceilingWidth = ceiling.contentSize.width;
    [_parallaxNode addChild:ceiling z:4 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:5 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    

}

- (void)setUpPhysicsLandscape
{
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
        shape.friction = 0.2f;
        [_space addShape:shape];
    }
}

- (void)createCoins
{
    // Add coins - TODO: make random
    NSMutableArray *coinArray = [[NSMutableArray alloc] init];
    _coinArray = coinArray;
    
    Coin *coin1 = [[Coin alloc] initWithSpace:_space position:ccp(25,170)];
    [_gameNode addChild:coin1];
    [_coinArray addObject:coin1];
    
    Coin *coin2 = [[Coin alloc] initWithSpace:_space position:ccp(250,180)];
    [_gameNode addChild:coin2];
    [_coinArray addObject:coin2];
    
    Coin *coin3 = [[Coin alloc] initWithSpace:_space position:ccp(900,90)];
    [_gameNode addChild:coin3];
    [_coinArray addObject:coin3];

    Coin *coin4 = [[Coin alloc] initWithSpace:_space position:ccp(1300,200)];
    [_gameNode addChild:coin4];
    [_coinArray addObject:coin4];
    
    Coin *coin5 = [[Coin alloc] initWithSpace:_space position:ccp(1800,170)];
    [_gameNode addChild:coin5];
    [_coinArray addObject:coin5];
    
    Coin *coin6 = [[Coin alloc] initWithSpace:_space position:ccp(1900,130)];
    [_gameNode addChild:coin6];
    [_coinArray addObject:coin6];
}

- (void)createHammers
{
    // Add hammers -- TODO: Make Random
    NSMutableArray *hammerArray = [[NSMutableArray alloc] init];
    _hammerArray = hammerArray;
    
    Sledgehammer *hammer1 = [[Sledgehammer alloc] initWithSpace:_space position:ccp(20,170)];
    [_gameNode addChild:hammer1];
    [_hammerArray addObject:hammer1];
    
    Sledgehammer *hammer2 = [[Sledgehammer alloc] initWithSpace:_space position:ccp(500,180)];
    [_gameNode addChild:hammer2];
    [_hammerArray addObject:hammer2];
    
    
    Sledgehammer *hammer3 = [[Sledgehammer alloc] initWithSpace:_space position:ccp(1500,50)];
    [_gameNode addChild:hammer3];
    [_hammerArray addObject:hammer3];
}

- (void)touchStarted
{
    NSLog(@"Touch started.");
    if (!_gameOver){
        [_player flyWithForce];
    }
}

- (void)touchEnded
{
    NSLog(@"No longer touching.");
    if (!_gameOver) {
        [_player removeForces];

    }
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
    
    // Make the camera follow the player.
    if (_playerFollow == YES)
    {
        if (_player.position.x >= (_winSize.width / 2) )//&& _player.position.x < (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_player.position.x - (_winSize.width / 2)), 0);
        }
    }
    
    if (distanceScore < _player.position.x){
        distanceScore = _player.position.x;
        [scoreLabel setString:[NSString stringWithFormat:@"%d", score+distanceScore]];
    }
}
@end


