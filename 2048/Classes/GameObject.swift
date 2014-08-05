//
//  GameObjct.swift
//  2048
//
//  Created by Ilija Tovilo on 05/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class GameObject: CCResponder {

    public var view: View!
    
    override init() {
        super.init()
        loadView()
    }
    
    internal func loadView() {
        // Implemented in subclasses
        assert(false, "The loadView method must be overridden!")
    }
    
}
