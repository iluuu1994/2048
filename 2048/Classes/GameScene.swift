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
    
    private var _gameBoardMargin: Float = 20.0
    
    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.98, green: 0.97, blue: 0.94))
    }()
    
    lazy private var _gameBoard: GameBoard = {
        let gb = GameBoard(
            contentSize: Float(self.contentSize.width) - (self._gameBoardMargin * 2),
            tilesPerRow: 4
        )
        
        gb.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: gb.positionType.corner
        )
        
        gb.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gb.position = CGPoint(x: 0.5, y: 0.5)
        gb.delegate = self
        
        return gb
    }()
    
    lazy var _scoreLabel: CCLabelTTF = {
        let l = CCLabelTTF(string: "Score: 0", fontName: "HelveticaNeue-Bold", fontSize: 40)
        l.position = CGPoint(x: 0.5, y: 0.1)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .TopLeft
        )
        l.fontColor = CCColor(red: 0.47, green: 0.43, blue: 0.4)
        
        return l
    }()
    
    lazy var _restartButton: CCButton = {
        let l = Button(title: "RESTART", fontName: "HelveticaNeue-Bold", fontSize: 28)
        
        l.position = CGPoint(x: 0.5, y: 0.1)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        
        l.setTarget(self, selector: "restartGame")
        
        return l
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
        addChild(_scoreLabel)
        addChild(_restartButton)
    }
    
    
    
    // MARK: Target Actions
    
    func restartGame() {
        CCDirector.sharedDirector().replaceScene(GameScene.scene())
    }
    
}

extension GameScene: GameBoardDelegate {

    func playerScoreIncreased(by: Int, totalScore: Int) {
        _scoreLabel.string = "Score: \(totalScore)"
    }
    
    func playerWonWithScore(score: Int) {
        scheduleBlock({ (timer) in
            CCDirector.sharedDirector().replaceScene(YouWinScene.scene(gameScene: self, score: score))
        }, delay: kYouWonDelay)
    }
    
    func gameOverWithScore(score: Int) {
        scheduleBlock({ (timer) in
            CCDirector.sharedDirector().replaceScene(GameOverScene(score: score))
        }, delay: kGameOverDelay)
    }
    
}
