//
//  Helpers.swift
//  2048
//
//  Created by Ilija Tovilo on 31/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

func random(start: Float, stop: Float) -> Float {
    return start + (stop - start) * CCRANDOM_0_1()
}

func randomWhole(start: Int, stop: Int) -> Int {
    return start + Int(arc4random_uniform(UInt32(stop - start + 1)))
}
