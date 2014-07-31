//
//  GameScene.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@objc(TFGameScene)
class GameScene: CCScene {
    
    // MARK: Instanc Variables
    
    private var _gameBoardMargin: Float = 10.0
    
    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.98, green: 0.97, blue: 0.94))
    }()
    
    lazy private var _gameBoard: GameBoard = {
        let gb = GameBoard(
            contentSize: Float(self.contentSize.width) - (self._gameBoardMargin * 2),
            tilesPerRow: 4
        )
        gb.position = CGPoint(x: CGFloat(self._gameBoardMargin), y: 100)
        
        return gb
    }()

    
    
    // MARK: Init
    
    class func scene() -> GameScene {
        return GameScene()
    }
    
    init() {
        super.init()
        
        initSubnodes()
    }
    
    func initSubnodes() {
        addChild(_backgroundNode)
        addChild(_gameBoard)
    }
    
    
    
}
