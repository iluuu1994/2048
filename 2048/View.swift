//
//  GameObjectView.swift
//  2048
//
//  Created by Ilija Tovilo on 05/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class View: CCNode {
    
    // TODO: Make an unowned reference
    var gameObject: GameObject!
    
    init(gameObject: GameObject?) {
        self.gameObject = gameObject
    }
    
    override public var contentSize: CGSize {
        didSet {
            viewDidResizeTo(contentSize)
        }
    }
    
}
