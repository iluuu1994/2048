//
//  AppDelegate.swift
//  2048
//
//  Created by Ilija Tovilo on 01/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@UIApplicationMain
@objc(AppDelegate)
class AppDelegate: CCAppDelegate, UIApplicationDelegate {
    
    override func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]!) -> Bool {
        // Configure cocos2d
        setupCocos2dWithOptions([
            CCSetupShowDebugStats: true,
            CCSetupScreenOrientation: CCScreenOrientationPortrait,
        ])
        
        // Register custom font
        CCLabelTTF.registerCustomTTF("ClearSans-Bold.ttf")
        
        return true
    }

    override func startScene() -> CCScene! {
        return GameScene.scene()
    }

}
