//
//  HelloWorldScene.h
//  2048
//
//  Created by Ilija Tovilo on 24/07/14.
//  Copyright Ilija Tovilo 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene

// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end