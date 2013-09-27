//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Molly Twerk on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol InputLayerDelegate <NSObject>
- (void)touchStarted;
- (void)touchEnded;

@end

@interface InputLayer : CCLayer

@property (nonatomic, weak) id<InputLayerDelegate> delegate;

@end
