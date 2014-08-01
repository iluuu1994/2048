//
//  AppDelegate.swift
//  2048
//
//  Created by Ilija Tovilo on 01/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@objc(AppDelegate)
class AppDelegate: CCAppDelegate {
    
    override func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]!) -> Bool {
        setupCocos2dWithOptions([
            CCSetupShowDebugStats: true,
            CCSetupScreenOrientation: CCScreenOrientationPortrait,
        ])
        
        return true
    }

    override func startScene() -> CCScene! {
        return GameScene.scene()
    }

}
