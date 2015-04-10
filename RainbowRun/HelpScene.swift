//
//  HelpScene.swift
//  RainbowRun
//
//  Created by Alexander Saleh on 4/1/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation
import Spritekit


class HelpScene: SKScene {
    
    let backButton = SKSpriteNode(imageNamed: "backButton")
    let floor = SKSpriteNode(imageNamed: "floor") // The floor image that is placed infront of the background
    var playButtonSound = SKAction.playSoundFileNamed("RainbowRunButton.caf", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        addBG() // Placing the background on to the view
        self.addChild(self.floor) // This adds the floor to the view
        self.floor.anchorPoint = CGPointMake(0, 0.5) // Placing the anchorpoint for the floor image
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2)) // positioning the floor
        
        // self.backButton.anchorPoint = CGPointMake(0, 0.5)
        self.backButton.position = CGPointMake(CGRectGetMinX(self.frame) + 60, 87)
        self.addChild(self.backButton)
        
    }
    
    func addBG() { // A function that adds the background to the view
        var background = SKSpriteNode(imageNamed: "background")
        background.size.width = self.frame.size.width
        background.size.height = self.frame.size.height
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(background)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            runAction(playButtonSound)
            
        }
    }
    
    
    
    
    
    
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton {
                var scene = GameScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                //scene.anchorPoint = CGPointMake(CGRectGetMidX(HelpScene().frame), CGRectGetMidY(HelpScene().frame))
                skView.presentScene(scene)
            }
        }
        
    }
    
    
    
    
    
    
}
