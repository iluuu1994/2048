//
//  TilePlaceholder.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

class TilePlaceholder: CCNode {
    
    // MARK: Instance Variables
    
    lazy var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.8, green: 0.75, blue: 0.71),
            width: Float(self.contentSize.width),
            height: Float(self.contentSize.height))
    }()
    
    
    init(size: Float) {
        super.init()
        
        contentSize = CGSize(width: CGFloat(size), height: CGFloat(size))
        addChild(_backgroundNode)
    }
    
    
}
