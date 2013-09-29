//
//  ImageSlideShow.h
//  iOS App Dev
//
//  Created by Solveig Sif Gudmundsdottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"

@interface ImageSlideShow : CCLayer {
    
	NSNumber	*imageIndex;
	CCArray		*images;
	CCSprite	*currentImage;
	CCSprite	*oldImage;
    
}

@end
