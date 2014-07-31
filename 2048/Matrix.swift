//
//  Matrix.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class Matrix<T> {

    // MARK: Instance Variables
    
    public let width: Int
    public let height: Int
    private var _items: [T?]
    
    
    
    // MARK: Init
    
    init(width: Int, height: Int) {
        assert(width >= 0, "The width of the matrix needs to be larger or equal to 0.")
        assert(height >= 0, "The height of the matrix needs to be larger or equal to 0.")
        
        self.width = width
        self.height = height
        _items = Array<T?>(count: self.width * self.height, repeatedValue: nil)
    }
    
    
    
    // MARK: Methods
    
//    // TODO: Implement
//    var indexOfItem: (x: Int, y: Int) {
//    
//    }
    
    
    
    // MARK: Subscript
    
    subscript(x: Int, y: Int) -> T? {
        get {
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            return _items[x + (y * width)]
        }
        set(newValue) {
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            _items[x + (y * width)] = newValue
        }
    }
    
}


extension Matrix: Sequence {

    public func generate() -> MatrixGenerator<T> {
        return MatrixGenerator(matrix: self)
    }
    
}

public class MatrixGenerator<T>: Generator {
    
    private let _matrix: Matrix<T>
    private var _currentX = 0
    private var _currentY = 0
    
    init(matrix: Matrix<T>) {
        _matrix = matrix
    }
    
    public func next() -> (x: Int, y: Int, value: T?)? {
        var next = (_currentX, _currentY, _matrix[_currentX, _currentY])
        
        _currentX++
        if _currentX >= _matrix.width {
            _currentX = 0
            _currentY++
        }
        if _currentY >= _matrix.height {
            return nil
        }
        
        return next
    }
    
}
