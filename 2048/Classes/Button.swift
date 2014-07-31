//
//  Button.swift
//  2048
//
//  Created by Ilija Tovilo on 31/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

class Button: CCButton {
    
    // MARK: Variables
    
    lazy var _backgroundNode: CCNodeColor = {
        var bn = CCNodeColor(color: CCColor(red: 0.73, green: 0.68, blue: 0.63),
            width: Float(self.contentSize.width),
            height: Float(self.contentSize.height))
        
        return bn
    }()
    
    
    
    // MARK: Init
    
    init(title: String!) {
        super.init(title: title)
    }
    
    init(title: String!, fontName: String!, fontSize size: Float) {
        super.init(title: title, fontName: fontName, fontSize: size)
        initDesign()
    }
    
    init(title: String!, spriteFrame: CCSpriteFrame!, highlightedSpriteFrame highlighted: CCSpriteFrame!, disabledSpriteFrame disabled: CCSpriteFrame!) {
        super.init(title: title, spriteFrame: spriteFrame, highlightedSpriteFrame: highlighted, disabledSpriteFrame: disabled)
    }
    
    func initDesign() {
        zoomWhenHighlighted = false
        color = CCColor(red: 1, green: 1, blue: 1)
        addChild(_backgroundNode, z: -1)
    }
    
}
