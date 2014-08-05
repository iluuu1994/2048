//
//  GameBoardView.swift
//  2048
//
//  Created by Ilija Tovilo on 05/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class GameBoardView: View {

    // MARK: Variables

    private var _tilePlaceholderViews: Matrix<TilePlaceholderView>

    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.73, green: 0.68, blue: 0.63),
                    width: Float(self.contentSize.width),
                    height: Float(self.contentSize.height))
    }()

    public var gameBoard: GameBoard {
        get {
            return gameObject as GameBoard
        }
    }

    private let _borderWidth: CGFloat = 10.0



    // MARK: Init

    init(gameBoard: GameBoard) {
        _tilePlaceholderViews = Matrix<TilePlaceholderView>(width: gameBoard.gridSize, height: gameBoard.gridSize)

        super.init(gameObject: gameBoard)
        
        buildGrid()
        userInteractionEnabled = true
    }

    override public func viewDidResizeTo(newViewSize: CGSize) {
        super.viewDidResizeTo(newViewSize)
        layoutTileViews()
    }

    private func buildGrid() {
        addChild(_backgroundNode)
        
        for x in 0..<gameBoard.gridSize {
            for y in 0..<gameBoard.gridSize {
                let tilePlaceholderView = TilePlaceholderView()
                addChild(tilePlaceholderView)
                _tilePlaceholderViews[x, y] = tilePlaceholderView
            }
        }
        
        layoutTileViews()
    }

    private func layoutTileViews() {
        _backgroundNode.contentSize = contentSize

        for x in 0..<gameBoard.gridSize {
            for y in 0..<gameBoard.gridSize {
                if let tilePlaceholderView = _tilePlaceholderViews[x, y] {
                    tilePlaceholderView.contentSize = CGSize(width: tileSize, height: tileSize)
                    tilePlaceholderView.position = tilePosition((x: x, y: y))
                }

                if let tile = gameBoard._tiles[x, y] {
                    tile.tileView.contentSize = CGSize(width: tileSize, height: tileSize)
                    tile.tileView.position = tilePosition((x: x, y: y))
                }
            }
        }
    }



    // MARK: Tiles

    private func addTileView(tileView: TileView, to: TilePosition) {
        tileView.position = tilePosition(to)
        tileView.contentSize = CGSize(width: tileSize, height: tileSize)
        addChild(tileView)
    }

    internal func spawnTileView(tileView: TileView, at: TilePosition) {
        addTileView(tileView, to: at)
        tileView.runAction(tileView.spawnAnimation())
    }
    
    internal func removeTileView(tileView: TileView) {
        tileView.removeFromParent()
    }
    
    internal func moveTileView(tileView: TileView, to:TilePosition) {
        tileView.runAction(tileView.moveToAnimation(tilePosition(to)))
    }

    internal func mergeTileView(tileView: TileView, _ secondTileView: TileView, intoTileView mergedTileView: TileView, mergePosition: TilePosition) {
        mergedTileView.visible = false
        addTileView(mergedTileView, to: mergePosition)
                            
        tileView.runAction(CCActionSequence(
            one: tileView.moveToAnimation(tilePosition(mergePosition)),
            two: CCActionCallBlock(block: {
                tileView.removeFromParent()
                secondTileView.removeFromParent()
                mergedTileView.visible = true
                mergedTileView.runAction(mergedTileView.mergeAnimation())
            })
        ))
    }



    // MARK: Touch handling
    
    private var _lastTouchBegan: CGPoint?

    override public func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        _lastTouchBegan = touch.locationInNode(self)
    }
    
    override public func touchMoved(touch: UITouch!, withEvent event: UIEvent!) {
        if let lastTouchBegan = _lastTouchBegan {
            let deltaX = touch.locationInNode(self).x - lastTouchBegan.x
            let deltaY = touch.locationInNode(self).y - lastTouchBegan.y
            
            if abs(deltaX) > 20 || abs(deltaY) > 20 {
                if abs(deltaX) > abs(deltaY) {
                    // Left or right swipe
                    if deltaX > 0 {
                        // Right
                        gameBoard.performSwipeInDirection(.Right)
                    } else {
                        // Left
                        gameBoard.performSwipeInDirection(.Left)
                    }
                } else {
                    // Up or down swipe
                    if deltaY > 0 {
                        // Up
                        gameBoard.performSwipeInDirection(.Up)
                    } else {
                        // Down
                        gameBoard.performSwipeInDirection(.Down)
                    }
                }
                
                _lastTouchBegan = nil
            }
        }
    }

    override public func touchEnded(touch: UITouch!, withEvent event: UIEvent!) {
        _lastTouchBegan = nil
    }



    // MARK: Helpers
    
    var boardSize: CGFloat {
        return contentSize.width
    }
    
    var tileSize: CGFloat {
        return (boardSize - (_borderWidth*CGFloat(gameBoard.gridSize + 1))) / CGFloat(gameBoard.gridSize)
    }
    
    func tilePosition(at: TilePosition) -> CGPoint {
        return CGPoint(
            x: CGFloat(_borderWidth + (CGFloat(at.x) * (tileSize + _borderWidth)) + tileSize / 2.0),
            y: CGFloat(_borderWidth + (CGFloat(at.y) * (tileSize + _borderWidth)) + tileSize / 2.0)
        )
    }
    
}
