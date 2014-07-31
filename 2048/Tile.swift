//
//  Tile.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class Tile: CCNode {
    
    // MARK: Instance Variables
    
    public let value: Int
    public var locked = false
    private var _backgroundColor: CCColor {
        switch value {
            case 2:
                return CCColor(red: 0.93, green: 0.89, blue: 0.86)
            case 4:
                return CCColor(red: 0.93, green: 0.88, blue: 0.79)
            case 8:
                return CCColor(red: 0.95, green: 0.69, blue: 0.49)
            case 16:
                return CCColor(red: 0.95, green: 0.58, blue: 0.41)
            case 32:
                return CCColor(red: 0.96, green: 0.49, blue: 0.39)
            case 64:
                return CCColor(red: 0.96, green: 0.37, blue: 0.26)
            
            case 128:
                return CCColor(red: 0.93, green: 0.81, blue: 0.47)
            case 256:
                return CCColor(red: 0.93, green: 0.8, blue: 0.41)
            case 512:
                return CCColor(red: 0.93, green: 0.78, blue: 0.35)
            case 1024:
                return CCColor(red: 0.93, green: 0.78, blue: 0.35)
            case 2048:
                return CCColor(red: 0.93, green: 0.78, blue: 0.35)
            default:
                return CCColor()
        }
    }
    
    private var _fontSize: Float {
        switch value {
            case 2:
                return 38
            case 4:
                return 38
            case 8:
                return 36
            case 16:
                return 34
            case 32:
                return 34
            case 64:
                return 34
            case 128:
                return 28
            case 256:
                return 26
            case 512:
                return 26
            case 1024:
                return 20
            case 2048:
                return 20
            default:
                return 20
        }
    }
    
    private var _fontColor: CCColor {
        switch value {
            case 2:
                return CCColor(red: 0.47, green: 0.43, blue: 0.4)
            case 4:
                return CCColor(red: 0.47, green: 0.43, blue: 0.4)
            case 8:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 16:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 32:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 64:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 128:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 256:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 512:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 1024:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            case 2048:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
            default:
                return CCColor(red: 0.98, green: 0.96, blue: 0.95)
        }
    }
    
    lazy var _backgroundNode: CCNodeColor = {
        CCNodeColor(color: self._backgroundColor,
            width: Float(self.contentSize.width),
            height: Float(self.contentSize.height))
    }()
    
    lazy var _label: CCLabelTTF = {
        let l = CCLabelTTF(string: String(self.value), fontName: "HelveticaNeue-Bold", fontSize: CGFloat(self._fontSize))
        l.position = CGPoint(x: 0.5, y: 0.5)
        l.positionType = CCPositionType(
            xUnit: .Normalized,
            yUnit: .Normalized,
            corner: .BottomLeft
        )
        l.fontColor = self._fontColor
        
        return l
    }()
    
    
    init(size: Float, value: Int) {
        self.value = value
        
        super.init()
        
        contentSize = CGSize(width: CGFloat(size), height: CGFloat(size))
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(_backgroundNode)
        addChild(_label)
    }
    
    
    public func canMergeWith(tile: Tile) -> Bool {
        return value == tile.value && !locked && !tile.locked
    }
    
    
    // MARK: Actions
    
    public func moveToAnimation(position: CGPoint) -> CCActionInterval {
        return CCActionMoveTo(duration: kTileSwipeAnimationDuration, position: position)
    }
    
    public func spawnAnimation() -> CCActionInterval {
        return CCActionSequence(
            one: CCActionCallBlock({ self.scale = kTileSpawnScaleFrom }),
            two: CCActionScaleTo(duration: kTileSpawnScaleDuration, scale: kTileSpawnScaleTo)
        )
    }
    
    public func mergeAnimation() -> CCActionInterval {
        return CCActionSequence(
            one: CCActionScaleTo(duration: kTileMergeScaleDuration, scale: kTileMergeScaleTo),
            two: CCActionScaleTo(duration: kTileMergeScaleDuration, scale: kTileMergeScaleFrom)
        )
    }
    
//    override public func runAction(action: CCAction!) -> CCAction! {
//        stopAllActions()
//        return super.runAction(action)
//    }

}
