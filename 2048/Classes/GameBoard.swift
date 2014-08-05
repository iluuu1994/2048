//
//  GameBoard.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation


/**
 * The GameBoardDelegate is used to define an interface that can be used to receive information about the progress of the game.
 */
protocol GameBoardDelegate: class {
    func playerScoreIncreased(by: Int, totalScore: Int)
    func playerWonWithScore(score: Int)
    func gameOverWithScore(score: Int)
}


/**
 * The ForInLoop is used to define an interface for for loops
 */
private struct ForLoop<T> {
    let initialValue: T
    let condition: (T) -> Bool
    let incrementalValue: T
    
    init(_ initialValue: T, _ condition: (T) -> Bool, _ incrementalValue: T) {
        self.initialValue = initialValue
        self.condition = condition
        self.incrementalValue = incrementalValue
    }
}

typealias TilePosition = (x: Int, y: Int)


@objc(TFGameBoard)
public class GameBoard: GameObject {
    
    // MARK: Instance Variables
    
    let gridSize: Int
    internal(set) var score: Int = 0
    
    // TODO: Check why program crashes when this is set to GameBoardDelegate
    weak var delegate: GameScene?
    
    internal let _tiles: Matrix<Tile>
    private var _didShowYouWinScene = false
    
    public var gameBoardView: GameBoardView! {
        get {
            return view as GameBoardView
        }
    }
    

    
    // MARK: Initialization
    
    init(gridSize: Int) {
        assert(gridSize > 0, "Game Board must have a grid size of greater than 0!")
        self.gridSize = gridSize
        _tiles = Matrix<Tile>(width: self.gridSize, height: self.gridSize)
        
        super.init()
        
        for times in 0..<2 {
            spawnRandomTile()
        }
    }
    
    override func loadView() {
        view = GameBoardView(gameBoard: self)
    }
    
    
    
    
    
    // MARK: Game Logic
    
    func spawnRandomTile() {
        let possiblePositions = emptyTiles()
        let position = possiblePositions[randomWhole(0, possiblePositions.count - 1)]
        let value = randomWhole(0, 6) <= 5 ? 2 : 4
        
        let tile = Tile(value: value)
        addTile(tile, to: position)
        gameBoardView.spawnTileView(tile.tileView, at: position)
    }
    
    func emptyTiles() -> [TilePosition] {
        var emptyTiles = Array<TilePosition>()
        for x in 0..<_tiles.width {
            for y in 0..<_tiles.height {
                if _tiles[x, y] == nil {
                    emptyTiles += [(x, y)]
                }
            }
        }
        
        return emptyTiles
    }
    
    func addTile(tile: Tile, to: TilePosition) {
        assert(_tiles[to.x, to.y] == nil, "The tile position is not free.")
        _tiles[to.x, to.y] = tile
    }
    
    func removeTile(at: TilePosition) {
        assert(_tiles[at.x, at.y] != nil, "There is no tile at this position.")
        
        if let tile = _tiles[at.x, at.y] {
            _tiles[at.x, at.y] = nil
        }
    }
    
    func moveTile(at: TilePosition, to:TilePosition) {
        assert(!(at.x == to.x && at.y == to.y), "The tile is already at this location.")
        assert(_tiles[to.x, to.y] == nil, "The new tile position is not free.")
        
        if let tile = _tiles[at.x, at.y] {
            _tiles[at.x, at.y] = nil
            _tiles[to.x, to.y] = tile
            
            gameBoardView.moveTileView(tile.tileView, to: to)
        }
    }
    
    func performSwipeInDirection(direction: SwipeDirection) {
        var firstI: ForLoop<Int>!
        var secondI: ForLoop<Int>!
        var ppI: ForLoop<Int>!
        var gV: (Int, Int) -> TilePosition
        
        switch direction {
            case .Left:
                firstI = ForLoop(1, {$0 < self._tiles.width}, 1)
                secondI = ForLoop(0, {$0 < self._tiles.height}, 1)
                ppI = ForLoop(0 /* Ignored */, {$0 >= 0}, -1)
                gV = {($0,$1)}
            case .Right:
                firstI = ForLoop(self._tiles.width - 2, {$0 >= 0}, -1)
                secondI = ForLoop(0, {$0 < self._tiles.height}, 1)
                ppI = ForLoop(0 /* Ignored */, {$0 < self._tiles.height}, 1)
                gV = {($0,$1)}
            case .Up:
                firstI = ForLoop(self._tiles.height - 2, {$0 >= 0}, -1)
                secondI = ForLoop(0, {$0 < self._tiles.width}, 1)
                ppI = ForLoop(0 /* Ignored */, {$0 < self._tiles.height}, 1)
                gV = {($1,$0)}
            case .Down:
                firstI = ForLoop(1, {$0 < self._tiles.height}, 1)
                secondI = ForLoop(0, {$0 < self._tiles.width}, 1)
                ppI = ForLoop(0 /* Ignored */, {$0 >= 0}, -1)
                gV = {($1,$0)}
        }
        
        var validSwipe = false
        var hasMerged = false
        
        for var firstV = firstI.initialValue; firstI.condition(firstV); firstV += firstI.incrementalValue {
            for var secondV = secondI.initialValue; secondI.condition(secondV); secondV += secondI.incrementalValue {
                let tilePos = gV(firstV, secondV)
                
                if let tile = _tiles[tilePos.x, tilePos.y] {
                    var newPos: TilePosition?
                    
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
                            
                            let mergedTile = Tile(value: tile.value + fixedTile.value)
                            mergedTile.locked = true
                            
                            addTile(mergedTile, to: nnNewPos)
                            
                            gameBoardView.mergeTileView(
                                tile.tileView,
                                fixedTile.tileView,
                                intoTileView: mergedTile.tileView,
                                mergePosition: nnNewPos
                            )
                            
                            
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
            view.scheduleBlock({ (timer) in
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
    
    func enclosingTilesOfTile(at: TilePosition) -> [Tile] {
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
    
}
