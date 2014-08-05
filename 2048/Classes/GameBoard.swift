//
//  GameBoard.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

protocol GameBoardDelegate: class {
    func playerScoreIncreased(by: Int, totalScore: Int)
    func playerWonWithScore(score: Int)
    func gameOverWithScore(score: Int)
}

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
    var score: Int = 0
    
    // TODO: Check why program crashes when this is set to GameBoardDelegate
    weak var delegate: GameScene?
    
    private let _tiles: Matrix<Tile>
    private let _borderWidth: Float = 10.0
    private var _didShowYouWinScene = false
    
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
        
        for times in 0..<2 {
            spawnRandomTile()
        }
    }
    
    
    
    // MARK: Game Logic
    
    func spawnRandomTile() {
        let possiblePositions = emptyTiles()
        let position = possiblePositions[randomWhole(0, possiblePositions.count - 1)]
        let value = randomWhole(0, 6) <= 5 ? 2 : 4
        
        let tile = Tile(size: tileSize, value: value)
        addTile(tile, x: position.x, y: position.y)
        tile.runAction(tile.spawnAnimation())
    }
    
    func emptyTiles() -> [(x: Int, y: Int)] {
        var emptyTiles = Array<(x: Int, y: Int)>()
        for x in 0..<_tiles.width {
            for y in 0..<_tiles.height {
                if _tiles[x, y] == nil {
                    emptyTiles += [(x, y)]
                }
            }
        }
        
        return emptyTiles
    }
    
    func addTile(tile: Tile, x: Int, y: Int) {
        if let oldTile = _tiles[x,y] {
            oldTile.removeFromParent()
        }
        
        _tiles[x, y] = tile
        tile.position = tilePosition(x, y)
        addChild(tile)
    }
    
    func removeTile(at: (x: Int, y: Int)) {
        if let tile = _tiles[at.x, at.y] {
            _tiles[at.x, at.y] = nil
        }
    }
    
    func moveTile(at: (x: Int, y: Int), to:(x: Int, y: Int)) {
        assert(!(at.x == to.x && at.y == to.y), "The tile is already at this location.")
        assert(_tiles[to.x, to.y] == nil, "The new tile position is not free.")
        
        if let tile = _tiles[at.x, at.y] {
            _tiles[at.x, at.y] = nil
            _tiles[to.x, to.y] = tile
            tile.runAction(tile.moveToAnimation(tilePosition(to.x, to.y)))
        }
    }
    
    func performSwipeInDirection(direction: SwipeDirection) {
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
        
        var validSwipe = false
        var hasMerged = false
        
        for var firstV = firstI.initialValue; firstI.condition(firstV); firstV += firstI.incrementalValue {
            for var secondV = secondI.initialValue; secondI.condition(secondV); secondV += secondI.incrementalValue {
                let tilePos = gV(firstV, secondV)
                
                if let tile = _tiles[tilePos.x, tilePos.y] {
                    var newPos: (x: Int, y: Int)?
                    
                    possiblePositions: for var pp = firstV + ppI.incrementalValue; ppI.condition(pp); pp += ppI.incrementalValue {
                        let possiblePos = gV(pp, secondV)
                        
                        if let fixedTile = _tiles[possiblePos.x, possiblePos.y] {
                            if tile.canMergeWith(fixedTile) {
                                newPos = possiblePos
                            }
                            break possiblePositions
                        } else {
                            newPos = possiblePos
                        }
                    }
                    
                    if let nnNewPos = newPos {
                        validSwipe = true
                        
                        if let fixedTile = _tiles[nnNewPos.x, nnNewPos.y] {
                            // Move the tile and merge it with the other tile
                            hasMerged = true
                            
                            removeTile(nnNewPos)
                            removeTile(tilePos)
                            
                            let mergedTile = Tile(size: tileSize, value: tile.value + fixedTile.value)
                            mergedTile.locked = true
                            mergedTile.visible = false
                            
                            addTile(
                                mergedTile,
                                x: nnNewPos.x,
                                y: nnNewPos.y
                            )
                            
                            tile.runAction(CCActionSequence(
                                one: tile.moveToAnimation(tilePosition(nnNewPos.x, nnNewPos.y)),
                                two: CCActionCallBlock(block: {
                                    tile.removeFromParent()
                                    fixedTile.removeFromParent()
                                    mergedTile.visible = true
                                    mergedTile.runAction(mergedTile.mergeAnimation())
                                })
                            ))
                            
                            increaseScore(mergedTile.value)
                        } else {
                            // Just move the tile
                            moveTile(tilePos, to: nnNewPos)
                        }
                    }
                }
            }
        }
        
        if validSwipe {
            // Spawn a new tile on every move
            scheduleBlock({ (timer) in
                self.spawnRandomTile()
                self.checkForGameOver()
            }, delay: kTileSpawnDelay)
            
            if !hasMerged {
                OALSimpleAudio.sharedInstance().playEffect("Move.wav")
            } else {
                OALSimpleAudio.sharedInstance().playEffect("Merge.wav")
            }
        }
        
        unlockAllTiles()
    }
    
    func increaseScore(by: Int) {
        score += by
        
        if let nnDelegate = delegate {
            nnDelegate.playerScoreIncreased(by, totalScore: score)
            
            if by == 2048 {
                youWin()
            }
        }
    }
    
    func unlockAllTiles() {
        for x in 0..<_tiles.width {
            for y in 0..<_tiles.height {
                if let tile = _tiles[x, y] {
                    tile.locked = false
                }
            }
        }
    }
    
    func enclosingTilesOfTile(at: (x: Int, y: Int)) -> [Tile] {
        var enclosingTiles = [Tile]()
        
        if let tile = _tiles[at.x, at.y] {
            for (etX, etY) in [(at.x + 1, at.y), (at.x - 1, at.y), (at.x, at.y + 1), (at.x, at.y - 1)] {
                if etX >= 0 && etX < _tiles.width && etY >= 0 && etY < _tiles.height {
                    if let enclosingTile = _tiles[etX, etY] {
                        enclosingTiles += [enclosingTile]
                    }
                }
            }
        }
        
        return enclosingTiles
    }
    
    func checkForGameOver() {
        if emptyTiles().count == 0 {
            for x in 0..<_tiles.width {
                for y in 0..<_tiles.height {
                    if let tile = _tiles[x, y] {
                        let enclosingTiles = enclosingTilesOfTile((x: x, y: y))
                        
                        for enclosingTile in enclosingTiles {
                            if tile.value == enclosingTile.value {
                                return
                            }
                        }
                    }
                }
            }
            
            gameOver()
        }
    }
    
    func gameOver() {
        if let nnDelegate = delegate {
            nnDelegate.gameOverWithScore(score)
        }
    }
    
    func youWin() {
        if !_didShowYouWinScene {
            if let nnDelegate = delegate {
                nnDelegate.playerWonWithScore(score)
            }
            
            _didShowYouWinScene = true
        }
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
            x: CGFloat(Float(_borderWidth) + (Float(x) * (tileSize + Float(_borderWidth))) + Float(tileSize / 2.0)),
            y: CGFloat(Float(_borderWidth) + (Float(y) * (tileSize + Float(_borderWidth))) + Float(tileSize / 2.0))
        )
    }
    
}
