//
//  GameScene.swift
//  RainbowRun
//
//  Created by Alexander Saleh on 4/1/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import SpriteKit
import UIKit
import AudioToolbox


class GameScene: SKScene {
    
    var floor = SKSpriteNode(imageNamed: "floor") // The floor image that is placed infront of the background
    var playbutton = SKSpriteNode(imageNamed: "startButtonNotPressed") // This is the start button
    var highScoreButton = SKSpriteNode(imageNamed: "highscoreButtonNotPressed")
    var helpButton = SKSpriteNode(imageNamed: "helpButtonNotPressed")
    var playButtonSound = SKAction.playSoundFileNamed("RainbowRunButton.caf", waitForCompletion: false)
    var music = SKAction.playSoundFileNamed("music1.caf", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here*/
        addBG() // Placing the background on to the view
        
        //playMusic()
        
        self.floor.anchorPoint = CGPointMake(0, 0.5) // Placing the anchorpoint for the floor image
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2)) // positioning the floor
        self.addChild(self.floor) // This adds the floor to the view
        
        self.playbutton.position = CGPointMake(CGRectGetMidX(self.frame), 270) // Setting the position for the startbutton
        self.addChild(self.playbutton) // Adding the playbutton to the view
        
        self.highScoreButton.position = CGPointMake(/*CGRectGetMidX(self.frame) - */ 75, 87)
        self.addChild(self.highScoreButton)
        
        self.helpButton.position = CGPointMake(CGRectGetMidX(self.frame) + 85, 87)
        self.addChild(self.helpButton)
        
        
    }
    
    
    
    
    func addBG() { // A function that adds the background to the view
        var background = SKSpriteNode(imageNamed: "background")
        background.size.width = self.frame.size.width
        background.size.height = self.frame.size.height
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(background)
        
        
    }
    
    func playMusic() {
        runAction(self.music)
    }
    
    
    
    
    
    
    
    // This is the touch event that takes place when the playbutton gets pressed
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playbutton {
                runAction(playButtonSound)
                
                
            } else {
                if self.nodeAtPoint(location) == self.helpButton {
                    
                    runAction(playButtonSound)
                    
                }
                
            }
            
        }
    }
    
    override func  touchesEnded(touches: NSSet, withEvent: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playbutton {
                runAction(playButtonSound)
                var scene = InGameScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.anchorPoint = CGPointMake(CGRectGetMidX(GameScene().frame), CGRectGetMidY(GameScene().frame))
                skView.presentScene(scene)
            } else {
                if self.nodeAtPoint(location) == self.helpButton {
                    var scene = HelpScene(size: self.size)
                    runAction(playButtonSound)
                    let skView = self.view as SKView!
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .ResizeFill
                    scene.size = skView.bounds.size
                    //scene.anchorPoint = CGPointMake(CGRectGetMidX(GameScene().frame), CGRectGetMidY(GameScene().frame))
                    skView.presentScene(scene)
                }
            }
            
        }
    }
    
    
    
}