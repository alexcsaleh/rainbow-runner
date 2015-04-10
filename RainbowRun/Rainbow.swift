//
//  Rainbow.swift
//  RainbowRun
//
//  Created by Alexander Saleh on 4/1/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation
import SpriteKit

class Rainbow: SKSpriteNode {
    
    var direction = CGPointZero
    var index:Int = 0
    
    init(position: CGPoint, texture: SKTexture, index:Int) {
        
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        
        self.position = position
        self.index = index
        self.name = "rainbow_" + index.description
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(delta: NSTimeInterval) {
        
    }
    
    func fadeOut(duration:NSTimeInterval){
        
        runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(1),
            SKAction.removeFromParent()]))
        
    }
    
    var isBlack: Bool {
        get {
            return texture?.description.rangeOfString("black") != nil
        }
        
    }
}