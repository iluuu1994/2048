//
//  GameOverScene.swift
//  2048
//
//  Created by Ilija Tovilo on 31/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@objc(TFGameOverScene)
class GameOverScene: CCScene {
    
    // MARK: Instanc Variables
    
    private let _score: Int
    
    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.98, green: 0.97, blue: 0.94))
    }()
    
    lazy var _gameOverLabel: CCLabelTTF = {
        let l = CCLabelTTF(string: "Game Over!", fontName: "HelveticaNeue-Bold", fontSize: 40)
        l.position = CGPoint(x: 0.5, y: 0.55)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        l.fontColor = CCColor(red: 0.47, green: 0.43, blue: 0.4)
        
        return l
    }()
    
    lazy var _scoreLabel: CCLabelTTF = {
        let l = CCLabelTTF(string: "Score: \(self._score)", fontName: "HelveticaNeue-Bold", fontSize: 28)
        l.position = CGPoint(x: 0.5, y: 0.45)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        l.fontColor = CCColor(red: 0.67, green: 0.63, blue: 0.6)
        
        return l
    }()
    
    lazy var _tryAgainButton: CCButton = {
        let l = Button(title: "TRY AGAIN", fontName: "HelveticaNeue-Bold", fontSize: 28)

        l.position = CGPoint(x: 0.5, y: 0.3)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        
        l.setTarget(self, selector: "restartGame")
        
        return l
    }()
    
    
    
    // MARK: Init
    
    class func scene(#score: Int) -> GameOverScene {
        return GameOverScene(score: score)
    }
    
    init(score: Int) {
        _score = score
        
        super.init()
        
        initSubnodes()
    }
    
    func initSubnodes() {
        addChild(_backgroundNode)
        addChild(_gameOverLabel)
        addChild(_scoreLabel)
        addChild(_tryAgainButton)
    }
    
    
    // MARK: Target Actions
    
    func restartGame() {
        CCDirector.sharedDirector().replaceScene(GameScene.scene())
    }
    
}