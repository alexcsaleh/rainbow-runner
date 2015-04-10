//
//  InGameScene.swift
//  RainbowRun
//
//  Created by Alexander Saleh on 4/1/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import SPriteKit
import UIKit
import Foundation
import AudioToolbox
import AVFoundation




class InGameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    let floor = SKSpriteNode(imageNamed: "floor")
    
    let hero: SKSpriteNode
    
    let rainbowTextures = SKTexture()
    

    
    // The maximum left x value of the screen
    var frameMaxLeft:CGFloat //= -144//CGRectGetMinX(CGRect())
    var frameMaxRight:CGFloat //= 144//CGRectGetMaxX(CGRect())
  
    
    
    var scoreText = SKLabelNode(fontNamed: "Chalkduster")
    
    
    
    //var maxBarX: CGFloat = CGFloat(0)
    
    
    var heroBaseline = CGFloat(0)
    
    //var onGround = true
    
    let walkSound = SKAction.playSoundFileNamed("walk.caf", waitForCompletion: false)
    
    //var velocityY = CGFloat(0)
    let gravity = CGFloat(0.15) // In-game gravity
    
    // The score of the game
    var score = 0
    
    // Array for running hero textures
    var runningHeroTextures = [SKTexture]()
    
    //Array for death textures
    var deathTextures = [SKTexture]()
    
    
    
    
    // Waves in the ocean
    let waveMedium1: SKSpriteNode
    let waveMedium2: SKSpriteNode
    let waveMedium3: SKSpriteNode
    let waveMedium4: SKSpriteNode
    let waveSmall1: SKSpriteNode
    let waveSmall2: SKSpriteNode
    let waveSmall3: SKSpriteNode
    let waveSmall4: SKSpriteNode
    let waveSmall5: SKSpriteNode
    let wavesmall6: SKSpriteNode
    
    //array for running wave textures
    var waveTexturesMedium = [SKTexture]()
    var waveTexturesSmall = [SKTexture]()
    
    // Movement of hero left
    var heroMovingLeft = false
    // Movement of hero right
    var heroMovingRight = false
    
    // Hero walking Speed
    var heroSpeed:CGFloat = 2.5
    
    
    
    
    enum ColliderType:UInt32 { // The types of object that can collide
        case Hero = 1
        case Rainbow = 2
        case DarkRainbow = 3
    }
    
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        println("We are at the new scene!")
        
        frameMaxLeft = (CGRectGetMinX(self.frame)) + 16
        frameMaxRight = (CGRectGetMaxX(self.frame)) - 16
        loadLevel()
        
        self.physicsWorld.contactDelegate = self
        
        //the anchorpoint of the spawningbar
        self.floor.anchorPoint = CGPointMake(0, 0.5) //(0.15, 0.5)
        
        
        // The position of the floor
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2))
        
        
        
        // Position of the baseline(where the hero walk on top of)
        self.heroBaseline = self.floor.position.y - 78
        
        // Starting position of the hero
        self.hero.position =  CGPointMake(CGRectGetMinX(self.frame) + (self.hero.size.width / 0.34), (self.heroBaseline))
       
        
        
        
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), 20)
        
        
        self.addChild(self.waveMedium1)
        self.addChild(self.waveMedium2)
        self.addChild(self.waveMedium3)
        self.addChild(self.waveMedium4)
        self.addChild(self.waveSmall1)
        self.addChild(self.waveSmall2)
        self.addChild(self.waveSmall3)
        self.addChild(self.waveSmall4)
        self.addChild(self.waveSmall5)
        self.addChild(self.wavesmall6)
        self.addChild(self.floor)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
    }
    
    
    
    
    
    
    
    
    /* Function that loads the InGameScene level and all of its textures */
    func loadLevel() {
        addBG()
        loadAllWaveTextures()
        runWaveAnimations()
        loadHeroTextures()
        loadHeroMovement()
        loadHeroDeathTextures()
        removeRainbowsOnContact()
    }
    
    
    func loadAllWaveTextures() {
        loadMediumWaveTextures()
        loadSmallWaveTextures()
        
    }
    
    func runWaveAnimations(){
        runWaveMedium1()
        runWaveMedium2()
        runWaveMedium3()
        runWaveMedium4()
        runWaveSmall1()
        runWaveSmall2()
        runWaveSmall3()
        runWaveSmall4()
        runWaveSmall5()
        runWaveSmall6()
    }
    
    
    
    
    
    func walkingSound() {
        runAction(walkSound, withKey: "walkingSound")
    }
    
    
    

    
    /* Whenever the hero touches a darkrainbow the death function will be executed*/
    func didBeginContactBlackRainbow() {
        death()
    }
    
    /* Whenever the hero touches a dark rainbow this takes place*/
    func death() {
        var scene = GameScene(size: self.size)
        let skView = self.view as SKView!
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }
    
    
    
    
    func addBG() { // adding the same background func from the GameScene swift file(1st scene)
        var background = SKSpriteNode(imageNamed: "background")
        background.size.width = self.frame.size.width
        background.size.height = self.frame.size.height
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(background)
    }
    
    
    
    
    func loadMediumWaveTextures() {
        var waveAtlas = SKTextureAtlas(named: "waveMedium")
        
        for i in 0...1 {
            var textureName = "waveMedium\(i)"
            var temp = waveAtlas.textureNamed(textureName)
            waveTexturesMedium.append(temp)
        }
    }
    func loadSmallWaveTextures() {
        var waveAtlas = SKTextureAtlas(named: "waveSmall")
        
        for i in 0...1 {
            var textureName = "waveSmall\(i)"
            var temp = waveAtlas.textureNamed(textureName)
            waveTexturesSmall.append(temp)
        }
    }

    
    
    // This will start running the wave loop
    func runWaveMedium1() {
        waveMedium1.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveMedium1")
    }
    func runWaveMedium2() {
        waveMedium2.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveMedium2")
    }
    func runWaveMedium3() {
        waveMedium3.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveMedium3")
    }
    func runWaveMedium4() {
        waveMedium4.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveMedium4")
    }
    func runWaveSmall1() {
        waveSmall1.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall1")
    }
    func runWaveSmall2() {
        waveSmall2.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall2")
    }
    func runWaveSmall3() {
        waveSmall3.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall3")
    }
    func runWaveSmall4() {
        waveSmall4.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall4")
    }
    func runWaveSmall5() {
        waveSmall5.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall5")
    }
    func runWaveSmall6() {
        wavesmall6.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesSmall, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWaveSmall6")
    }
    
    
    
    
    
    func loadHeroDeathTextures() {
        var deathAtlas = SKTextureAtlas(named: "DeathAnimation")
        
        for i in 0...24 {
            var textureName = "death\(i)"
            var temp = deathAtlas.textureNamed(textureName)
            deathTextures.append(temp)
        }
    }
    
    func runDeathAnimation() {
        hero.runAction(SKAction.repeatAction(SKAction.animateWithTextures(deathTextures, timePerFrame: 0.083, resize: false, restore: true), count: 1))
    }

    
    
    
    
    
    
    /* Looping the animation of the hero*/
    func loadHeroTextures() {
        var runningLeftAtlas = SKTextureAtlas(named: "runLeft")
        
        for i in 1...9 {
            var textureName = "left_\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            runningHeroTextures.append(temp)
        }
    }
    
    // This will start running the run loop
    func runHero() {
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningHeroTextures, timePerFrame: 0.083, resize: false, restore: true)), withKey: "runHero")
    }
    
    
    
    /* this loads the hero movement-animations*/
    func loadHeroMovement() {
        hero.position.y -= hero.size.height / 2
        hero.position.x = -(scene!.size.width / 2)  + hero.size.width * 2
    }
    
    
    /* The function that makes the hero move into a certain direction*/
    func moveHero(direction: String) {
        if direction == "right" {
            heroMovingLeft = false
            hero.xScale = -1
            heroMovingRight = true
            
            
        } else {
            heroMovingRight = false
            hero.xScale = 1
            heroMovingLeft = true
        }
    }
    
    
    
    
    
    
    
    /* function that passes bounds to the screen*/
    func updateHeroPosition() {
        
        if hero.position.x < frameMaxLeft {
            cancelHeroMovesLeft()
            
        }
        
        if hero.position.x > frameMaxRight {
            cancelHeroMovesRight()
        }
        
        
        
        switch true {
            
        case heroMovingLeft:
            hero.position.x -= heroSpeed
            
        case heroMovingRight:
            hero.position.x += heroSpeed
            
        default:
            hero.position.x += 0
        }
        
    }
    
    
    
    
    
    
    /* Touches began function*/
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        var direction:String = determineDirection(touches)
        moveHero(direction)
        
        for touch: AnyObject in touches {
            if event.allTouches()!.count == 1 {
                runHero()
                walkingSound()
            }
        }
    //}
    
    
    
    
    
    
    
    /* this should be fired when another touch happen */
    //override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        //var direction:String = determineDirection(touches)
        moveHero(direction)
        
    }
    
    func determineDirection(touches:NSSet) -> String{
        
        var direction:String = ""
        let location = touches.anyObject()!.locationInNode(self)
        
        if location.x < 0 {
            
            direction = "left"
            
        }else{
            
            direction = "right"
        }
        
        return direction
        
    }
    
    
    // whenever a player lets go of the screen the player stops moving
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        cancelHeroMoves()
        removeActionForKey("walkingSound")
    }
    
    
    /* Removing rainbows whenever they hit the floor*/
    func removeRainbowsOnContact() {
        /*for rainbowTextures in self.rainbows as [SKNode] {
            
            if (rainbowTextures.position.y == heroBaseline) {
                
                self.removeChildrenInArray([rainbowTextures])
            }
        }*/
    }
    
    

    
    var rainbows:[Rainbow] = []
    enum Rainbows:Int { // Data about the rainbow generation
        
        case Max = 5
        case Distance = 112
        case Speed = 3
        case Delay =  55 //49 //38
        case TopDistance = 100
    }
    
    enum RainbowsType: String {
        
        case Black = "blackrainbow"
        case Normal = "rainbow"
    }

    
    var delayer = 0
    let positions:Array<Int> = [-143, -96, -48, 0, 48, 96, 143] // Spawning positions for the rainbows
    
    
    
    func isBlackNeeded()->Bool{
        
        var count = 0, value = true
        
        for rainbow:Rainbow in rainbows{
            
            if rainbow.isBlack{
                
                count++;
            }
        }
        
        if count > 4 {
            
            value = false
            
        }
        
        println(count)
        
        return value
    }
    
    
    
    
    
    override func didEvaluateActions()  {
        checkCollisions()
    }
    
    func checkCollisions(){
        
        var blackHitRainbows: [SKSpriteNode] = []
        enumerateChildNodesWithName(RainbowsType.Black.rawValue) { node, _ in
            let rainbow = node as SKSpriteNode
            if CGRectIntersectsRect(rainbow.frame, self.hero.frame) {
                blackHitRainbows.append(rainbow)
            }
        }
        for rainbow in blackHitRainbows {
            
            // Do whatever you want with every single collision
            
            runDeathAnimation()
            
        }
        
        var normalHitRainbows: [SKSpriteNode] = []
        enumerateChildNodesWithName(RainbowsType.Normal.rawValue) { node, _ in
            let rainbow = node as SKSpriteNode
            if CGRectIntersectsRect(rainbow.frame, self.hero.frame) {
                normalHitRainbows.append(rainbow)
            }
        }
        for rainbow in normalHitRainbows {
            
            // Do whatever you want with every single collision
            self.score += 10
        }
        println("---- blackHitRainbows \(blackHitRainbows)")
        println("---- normalHitRainbows \(normalHitRainbows)")
    }
    
    
    func generateRainbows(){
        
        // Generate a new Rainbow
        if rainbows.count <= Rainbows.Max.rawValue && delayer >= Rainbows.Delay.rawValue{
            
            var positionX: CGFloat
            var current:Rainbow
            var texture = rainbowTextures
            var spriteName:String
            
            if isBlackNeeded(){
                texture = SKTexture(imageNamed: "blackrainbow")
                spriteName = RainbowsType.Black.rawValue
                
            }else{
                
                texture = SKTexture(imageNamed: "rainbow")
                spriteName = RainbowsType.Normal.rawValue
                
            }
            
            let distance = CGFloat(Rainbows.Distance.rawValue)
            let topDistance = CGFloat(Rainbows.TopDistance.rawValue)
            let width = self.frame.size.width
            let random = Int(arc4random_uniform(UInt32(positions.count)))
            
            println("the \(texture.description) rainbow will be positioned at index \(random)")
            
            if rainbows.count == 0 {
                
                positionX = CGFloat(positions[random])// CGFloat.random(min: -width + texture.size().width, max: width - (distance * 3))
                current = Rainbow(position: CGPoint(x: positionX, y: texture.size().height + topDistance), texture: texture, index: rainbows.count)
                
                rainbows.insert(current, atIndex: 0)
                
            }else{
                let lastRainbow:Rainbow = rainbows.first!
                var min = lastRainbow.position.x + distance
                var max = width - distance
                
                if(min > max || (min + distance > max)){
                    
                    min  = CGFloat.random(min: -width/2, max: lastRainbow.position.x)
                }
                
                positionX = CGFloat(positions[random])// CGFloat.random(min: min, max: max)
                current = Rainbow(position: CGPoint(x: positionX, y:  texture.size().height + topDistance), texture: texture, index: rainbows.count)
                
                rainbows.insert(current, atIndex: 0)
            }
            delayer = 0
            
            current.name = spriteName
            addChild(current)
        }
        
        delayer++
    }
    
    
    
    func moveAndCheckRainbows(){
        var abs:CGFloat, found: Int?
        let timeInterval:NSTimeInterval = 0.35
        
        for rainbow:Rainbow in rainbows{
            
            rainbow.position.y -= CGFloat(Rainbows.Speed.rawValue)
            abs = rainbow.position.y + self.size.height
            
            if abs < 0{
                
                rainbow.fadeOut(timeInterval)
                
                for i in 0..<rainbows.count {
                    if rainbows[i] == rainbow {
                        found = i
                    }
                }
                
                if let index = found{
                    
                    rainbows.removeAtIndex(index)
                    
                }
                
            }
            //if rainbow.position.y >
            // println("I am at \(rainbow.position.y) and the size is \(self.size.height)")
            
        }
    }
   
    
    
    
    
    func cancelHeroMovesRight() {
        
        //hero.removeActionForKey("runHero")
        heroMovingRight = false
    }
    
    
    // this cancels the hero movement
    func cancelHeroMoves() {
        
        heroMovingLeft = false
        heroMovingRight = false
        //removeActionForKey("walkingSound")
        hero.removeAllActions()
    }
    
    
    func cancelHeroMovesLeft()  {
        //hero.removeActionForKey("runHero")
        heroMovingLeft = false
    }
    
    
    
    
    
    
    override init(size: CGSize) {
        self.waveMedium1 = SKSpriteNode(texture: SKTexture(imageNamed: "waveMedium0"))
        self.waveMedium1.position = CGPoint(x: 143, y: -84)
        self.waveMedium2 = SKSpriteNode(texture: SKTexture(imageNamed: "waveMedium0"))
        self.waveMedium2.position = CGPoint(x: 34, y: -75)
        self.waveMedium3 = SKSpriteNode(texture: SKTexture(imageNamed: "waveMedium0"))
        self.waveMedium3.position = CGPoint(x: -80, y: -78)
        self.waveMedium4 = SKSpriteNode(texture: SKTexture(imageNamed: "waveMedium0"))
        self.waveMedium4.position = CGPoint(x: 98, y: -65)
        self.waveSmall1 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.waveSmall1.position = CGPoint(x: -88, y: -33)
        self.waveSmall2 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.waveSmall2.position = CGPoint(x: -34, y: -55)
        self.waveSmall3 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.waveSmall3.position = CGPoint(x: 136, y: -40)
        self.waveSmall4 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.waveSmall4.position = CGPoint(x: -118, y: -58)
        self.waveSmall5 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.waveSmall5.position = CGPoint(x: 67, y: -48)
        self.wavesmall6 = SKSpriteNode(texture: SKTexture(imageNamed: "waveSmall0"))
        self.wavesmall6.position = CGPoint(x: -138, y: -35)
        self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
        self.hero.size.width = self.hero.size.width / 2
        self.hero.size.height = self.hero.size.height / 2
        self.hero.name = "hero"
        self.frameMaxLeft = CGFloat(0) //= (CGRectGetMinX(self.frame))
        self.frameMaxRight = CGFloat(0) //= (CGRectGetMaxX(self.frame))
        
        super.init(size: size)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func update(currentTime: NSTimeInterval) {
        updateHeroPosition()
        self.scoreText.text = String(self.score)
        
        
        
        
        
        
        
        generateRainbows()
        moveAndCheckRainbows()
    }
}


/*func blockRunner() {
for(block, blockStatus) in self.blockStatuses {
var thisBlock = self.childNodeWithName(block)
if blockStatus.shouldRunBlock() {
blockStatus.timeGapNextRun = randomBlockSpawn()
blockStatus.currentInterval = 0
blockStatus.isRunning = true
}

if blockStatus.isRunning {
if thisBlock!.position.x + (2.1 * blockDouble.size.width) > blockMaxX {
thisBlock?.position.x -= CGFloat(self.floorSpeed) //- self.block.size.width
} else {
thisBlock?.position.x += self.origRunningBlockPositionXPoint
blockStatus.isRunning = false
self.score++
if ((self.score % 5) == 0) {
self.floorSpeed++
}
self.scoreText.text = String(self.score)
}
} else {
blockStatus.currentInterval++
}
}
}*/

