//
//  TilePlaceholder.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class TilePlaceholderView: View {
    
    // MARK: Instance Variables
    
    lazy var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.8, green: 0.75, blue: 0.71),
            width: Float(self.contentSize.width),
            height: Float(self.contentSize.height))
    }()
    
    
    init() {
        super.init(gameObject: nil)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(_backgroundNode)
    }

    override public func viewDidResizeTo(newViewSize: CGSize) {
        super.viewDidResizeTo(newViewSize)
        _backgroundNode.contentSize = contentSize
    }
    
}
