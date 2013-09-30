//
//  CutScene.h
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "cocos2d.h"
#import "CCVideoPlayer.h"

@interface CutScene : CCLayer <CCVideoPlayerDelegate>
{
}

+(id) scene;

@end
