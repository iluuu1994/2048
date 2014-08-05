//
//  Tile.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class Tile: GameObject {
    
    // MARK: Instance Variables
    
    public let value: Int
    public var locked = false
    public var tileView: TileView! {
        get {
            return view as TileView
        }
    }
    
    init(value: Int) {
        self.value = value
        
        super.init()
    }
    
    override func loadView() {
        view = TileView(tile: self)
    }
    
    public func canMergeWith(tile: Tile) -> Bool {
        return value == tile.value && !locked && !tile.locked
    }

}
