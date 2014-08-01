//
//  YouWinScene.swift
//  2048
//
//  Created by Ilija Tovilo on 01/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@objc(TFYouWinScene)
class YouWinScene: CCScene {

    // MARK: Instanc Variables
    
    private let _gameScene: GameScene
    private let _score: Int
    
    lazy private var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: CCColor(red: 0.98, green: 0.97, blue: 0.94))
        }()
    
    lazy var _youWinLabel: CCLabelTTF = {
        let l = CCLabelTTF(string: "You Win!", fontName: "HelveticaNeue-Bold", fontSize: 40)
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
    
    lazy var _goOnButton: CCButton = {
        let l = Button(title: "GO ON", fontName: "HelveticaNeue-Bold", fontSize: 28)
        
        l.position = CGPoint(x: 0.5, y: 0.3)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        
        l.setTarget(self, selector: "goOn")
        
        return l
        }()
    
    
    
    // MARK: Init
    
    class func scene(#gameScene: GameScene, score: Int) -> YouWinScene {
        return YouWinScene(gameScene: gameScene, score: score)
    }
    
    init(gameScene: GameScene, score: Int) {
        _gameScene = gameScene
        _score = score
        
        super.init()
        
        initSubnodes()
    }
    
    func initSubnodes() {
        addChild(_backgroundNode)
        addChild(_youWinLabel)
        addChild(_scoreLabel)
        addChild(_goOnButton)
    }
    
    
    // MARK: Target Actions
    
    func goOn() {
        CCDirector.sharedDirector().replaceScene(_gameScene)
    }

}
