//
//  GameBoard.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation


struct ForInLoop<T> {
    let initialValue: T
    let condition: (T) -> Bool
    let incrementalValue: T
    
    init(_ initialValue: T, _ condition: (T) -> Bool, _ incrementalValue: T) {
        self.initialValue = initialValue
        self.condition = condition
        self.incrementalValue = incrementalValue
    }
}


@objc(TFGameBoard)
class GameBoard: CCNode {
    
    // MARK: Instance Variables
    
    let tilesPerRow: Int
    
    private let _tiles: Matrix<Tile>
    private let _borderWidth: Float = 10.0
    
    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.73, green: 0.68, blue: 0.63),
                    width: Float(self.contentSize.width),
                    height: Float(self.contentSize.height))
    }()
    

    
    // MARK: Initialization
    
    init(contentSize: Float, tilesPerRow: Int) {
        assert(tilesPerRow > 0, "Game Board must have a size of greater than 0!")
        self.tilesPerRow = tilesPerRow
        _tiles = Matrix<Tile>(width: tilesPerRow, height: tilesPerRow)
        
        super.init()
        
        self.contentSize = CGSize(width: CGFloat(contentSize), height: CGFloat(contentSize))
        initSubnodes()
        userInteractionEnabled = true
    }
    
    func initSubnodes() {
        addChild(_backgroundNode)
        
        for x in 0..<tilesPerRow {
            for y in 0..<tilesPerRow {
                let tilePlaceholder = TilePlaceholder(size: tileSize)
                tilePlaceholder.position = tilePosition(x, y)
                
                addChild(tilePlaceholder)
            }
        }
        
        spawnRandomTile()
    }
    
    
    
    // MARK: Game Logic
    
    func spawnRandomTile() {
        addTile(Tile(size: tileSize, value: 2), x: 0, y: 0)
        addTile(Tile(size: tileSize, value: 2), x: 1, y: 0)
        addTile(Tile(size: tileSize, value: 4), x: 0, y: 1)
    }
    
    func addTile(tile: Tile, x: Int, y: Int) {
        if let oldTile = _tiles[x,y] {
            oldTile.removeFromParent()
        }
        
        _tiles[x, y] = tile
        tile.position = tilePosition(x, y)
        addChild(tile)
    }
    
    func moveTile(at: (x: Int, y: Int), to:(x: Int, y: Int)) {
        assert(!(at.x == to.x && at.y == to.y), "The tile is already at this location.")
        assert(_tiles[to.x, to.y] == nil, "The new tile position is not free.")
        
        if let tile = _tiles[at.x, at.y] {
            _tiles[at.x, at.y] = nil
            _tiles[to.x, to.y] = tile
            tile.runAction(CCActionMoveTo(duration: kTileSwipeAnimationDuration, position: tilePosition(to.x, to.y)))
        }
    }
    
    func performSwipeInDirection(direction: SwipeDirection) {
        func canMoveTile(at: (x: Int, y: Int), to:(x: Int, y: Int)) -> Bool {
            let tile = _tiles[at.x, at.y]!
            
            if let fixedTile = _tiles[to.x, to.y] {
                return false
                
                if tile.value == fixedTile.value {
                    return true
                } else {
                    return false
                }
            }
            
            return true
        }
        
        func moveTileToPositionIfPossible(x: Int, y: Int, newX: Int, newY: Int) -> Bool {
            let tile = _tiles[x, y]!
            let fixedTile = _tiles[newX, newY]
            
            if let nnFixedTile = fixedTile {
                // Move the tile and merge it with the other tile
                if tile.value == nnFixedTile.value {
                    moveTile((x, y), to: (newX, newY))
                    
                    return true
                }
            } else {
                // Just move the tile
                moveTile((x, y), to: (newX, newY))
                
                return true
            }
            
            return false
        }
       
        
        var firstI: ForInLoop<Int>!
        var secondI: ForInLoop<Int>!
        var ppI: ForInLoop<Int>!
        var gV: (Int, Int) -> (x: Int, y: Int)
        
        switch direction {
            case .Left:
                firstI = ForInLoop(1, {$0 < self._tiles.width}, 1)
                secondI = ForInLoop(0, {$0 < self._tiles.height}, 1)
                ppI = ForInLoop(0 /* Ignored */, {$0 >= 0}, -1)
                gV = {($0,$1)}
            case .Right:
                firstI = ForInLoop(self._tiles.width - 2, {$0 >= 0}, -1)
                secondI = ForInLoop(0, {$0 < self._tiles.height}, 1)
                ppI = ForInLoop(0 /* Ignored */, {$0 < self._tiles.height}, 1)
                gV = {($0,$1)}
            case .Up:
                firstI = ForInLoop(self._tiles.height - 2, {$0 >= 0}, -1)
                secondI = ForInLoop(0, {$0 < self._tiles.width}, 1)
                ppI = ForInLoop(0 /* Ignored */, {$0 < self._tiles.height}, 1)
                gV = {($1,$0)}
            case .Down:
                firstI = ForInLoop(1, {$0 < self._tiles.height}, 1)
                secondI = ForInLoop(0, {$0 < self._tiles.width}, 1)
                ppI = ForInLoop(0 /* Ignored */, {$0 >= 0}, -1)
                gV = {($1,$0)}
        }
        
        
        for var firstV = firstI.initialValue; firstI.condition(firstV); firstV += firstI.incrementalValue {
            for var secondV = secondI.initialValue; secondI.condition(secondV); secondV += secondI.incrementalValue {
                let tilePos = gV(firstV, secondV)
                
                if let tile = _tiles[tilePos.x, tilePos.y] {
                    println("a tile!")
                    
                    var newPos: (x: Int, y: Int)?
                    
                    println("tiles position: \(tilePos)")
                    
                    possiblePositions: for var pp = firstV + ppI.incrementalValue; ppI.condition(pp); pp += ppI.incrementalValue {
                        let possiblePos = gV(pp, secondV)
                        
                        if canMoveTile(tilePos, possiblePos) {
                            newPos = possiblePos
                        } else {
                            break possiblePositions
                        }
                    }

                    if let nnNewPos = newPos {
                        moveTile(tilePos, to: nnNewPos)
                    }
                }
            }
        }
        
//        switch direction {
//            case .Left:
//                for x in 1..<_tiles.width {
//                    for y in 0..<_tiles.height {
//                        if let tile = _tiles[x, y] {
//                            var moveBy = 0
//                            tryEach: for var newX = x-1; newX >= 0; newX-- {
//                                if canMoveTile(x, y, newX, y) {
//                                    moveBy++
//                                } else {
//                                    break tryEach
//                                }
//                            }
//                        }
//                    }
//                }
//            case .Right:
//                for var x = _tiles.width-2; x >= 0; x-- {
//                    for y in 0..<_tiles.height {
//                        if let tile = _tiles[x, y] {
//                            var moveBy = 0
//                            tryEach: for var newX = x+1; newX < _tiles.width; newX++ {
//                                if canMoveTile(x, y, newX, y) {
//                                    moveBy++
//                                } else {
//                                    break tryEach
//                                }
//                            }
//                            
//                            if moveBy > 0 {
//                                moveTileToPositionIfPossible(x, y, x + moveBy, y)
//                            }
//                        }
//                    }
//                }
//            default:
//                println("ok")
//        }
        
    }
    
    
    
    
    
    
    // MARK: Touch handling
    
    private var _lastTouchBegan: CGPoint?

    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        _lastTouchBegan = touch.locationInNode(self)
    }
    
    override func touchMoved(touch: UITouch!, withEvent event: UIEvent!) {
        if let lastTouchBegan = _lastTouchBegan {
            let deltaX = touch.locationInNode(self).x - lastTouchBegan.x
            let deltaY = touch.locationInNode(self).y - lastTouchBegan.y
            
            if abs(deltaX) > 20 || abs(deltaY) > 20 {
                if abs(deltaX) > abs(deltaY) {
                    // Left or right swipe
                    if deltaX > 0 {
                        // Right
                        performSwipeInDirection(.Right)
                    } else {
                        // Left
                        performSwipeInDirection(.Left)
                    }
                } else {
                    // Up or down swipe
                    if deltaY > 0 {
                        // Up
                        performSwipeInDirection(.Up)
                    } else {
                        // Down
                        performSwipeInDirection(.Down)
                    }
                }
                
                _lastTouchBegan = nil
            }
        }
    }
    
    override func touchEnded(touch: UITouch!, withEvent event: UIEvent!) {
        _lastTouchBegan = nil
    }
    
    
    
    // MARK: Helpers
    
    var boardSize: Float {
        return Float(contentSize.width)
    }
    
    var tileSize: Float {
        return (boardSize - (_borderWidth*Float(tilesPerRow + 1))) / Float(tilesPerRow)
    }
    
    func tilePosition(x: Int, _ y: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(Float(_borderWidth) + (Float(x) * (tileSize + Float(_borderWidth)))),
            y: CGFloat(Float(_borderWidth) + (Float(y) * (tileSize + Float(_borderWidth))))
        )
    }
    
}
