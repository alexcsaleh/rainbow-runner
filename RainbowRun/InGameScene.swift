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
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // The maximum left x value of the screen
    var frameMaxLeft:CGFloat?
    var frameMaxRight:CGFloat?
    
    let rainbow = SKTexture(imageNamed: "rainbow")
    var scoreText = SKLabelNode(fontNamed: "Chalkduster")
    
    var origRunningFloorPositionXPoint = CGFloat(0)
    
    var maxBarX: CGFloat = CGFloat(0)
    
    var heroBaseline = CGFloat(0)
    
    //array for running wave textures
    var waveTexturesMedium = [SKTexture]()
    var waveTexturesSmall = [SKTexture]()
    var waveTexturesLarge = [SKTexture]()
    
    let walkSound = SKAction.playSoundFileNamed("walk.caf", waitForCompletion: false)
    
    //var velocityY = CGFloat(0)
    let gravity = CGFloat(0.15) // In-game gravity
    
    // The score of the game
    var score = 0
    
    // Array for running hero textures
    var runningHeroTextures = [SKTexture]()
    
    // Waves in the ocean
    let waveLarge: SKSpriteNode
    
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
    
    var rainbows:[Rainbow] = []
    enum Rainbows:Int { // Data about the rainbow generation
        
        case Max = 5
        case Distance = 112
        case Speed = 3
        case Delay =  55 //49 //38
        
    }
    
    enum RainbowsType:String{
        
        case Black = "blackrainbow"
        case Normal = "rainbow"
        
    }
    
    var delayer = 0
    let positions:Array<Int> = [-143, -96, -48, 0, 48, 96, 143] // Spawning positions for the rainbows
    
    override init(size: CGSize) {
        
        self.waveLarge = SKSpriteNode(texture: SKTexture(imageNamed: "wave0"))
        self.waveLarge.position = CGPoint(x: 85, y: -63)
        //self.waveMedium = SKSpriteNode(texture: SKTexture(imageNamed: "wave0"))
        //self.waveMedium.position = CGPoint(x: 129, y: -80)
        //self.waveSmall = SKSpriteNode(texture: SKTexture(imageNamed: "wave_0"))
        //self.waveSmall.position = CGPoint(x: -88, y: -50)
        self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
        self.hero.size.width = self.hero.size.width / 2
        self.hero.size.height = self.hero.size.height / 2
        self.hero.name = "hero"
        
        let halfHero =  hero.size.width / 2
        frameMaxLeft = -(screenSize.width/2) + halfHero
        frameMaxRight = screenSize.width / 2 - halfHero

        super.init(size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        println("We are at the new scene!")
        
        self.anchorPoint = CGPointMake(0.5, 0.0)
        
        loadLevel()
        
        self.physicsWorld.contactDelegate = self
        
        // The anchorpoint of the spawningbar
        self.floor.anchorPoint = CGPointMake(0, 0.5)
        
        // The position of the floor
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2))
        
        self.origRunningFloorPositionXPoint = self.floor.position.x
        self.maxBarX = self.floor.size.width - self.frame.size.width// geeft de total width van de spawningBar aan
        self.maxBarX *= -1
        
        // Position of the baseline(where the hero walk on top of)
        self.heroBaseline = self.floor.position.y + self.floor.size.height
        
        // Starting position of the hero
        self.hero.anchorPoint = CGPointMake(0.5, 0)
        self.hero.position = CGPointMake(0, floor.size.height - 30)
        
        /* Enable the physics*/
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.Hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.Rainbow.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.DarkRainbow.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.Rainbow.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.DarkRainbow.rawValue
        
        //self.rainbow.physicsBody = SKPhysicsBody(rectangleOfSize: self.rainbowCollider.size)
        
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), 20)
        
        
        
        self.addChild(self.waveLarge)
        self.addChild(self.floor)
        self.addChild(self.hero)
        self.addChild(self.scoreText)
        
        
    }
    
    func didBeginContact(contact:SKPhysicsContact){
        let node1:SKNode = contact.bodyA.node!
        let node2:SKNode = contact.bodyB.node!
        //
        println("the \(contact.bodyA) is touching the \(contact.bodyB)")

    }
    
    /* Function that loads the InGameScene level and all of its textures */
    func loadLevel() {
        
        addBG()
        
        loadAllWaveTextures()
        runWaveAnimations()
        
        loadHeroTextures()
        loadHeroMovement()
        
    }
    
    
    func loadAllWaveTextures() {
      
        waveTexturesLarge = loadAtlasTextures(atlas: "wave", count: 2)
        waveTexturesMedium = loadAtlasTextures(atlas: "waveMedium", count: 2)
        waveTexturesSmall = loadAtlasTextures(atlas: "waveSmall", count: 2)

    }
    
    func loadAtlasTextures(#atlas:String, count:Int) -> [SKTexture]{
    
        var waves = [SKTexture]()
    
        var waveAtlas = SKTextureAtlas(named: atlas)
        
        for i in 0..<count {
    
            var textureName = atlas + i.description
            var temp = waveAtlas.textureNamed(textureName)
            waves.append(temp)
        }
    
        return waves;
    
    }
    
    func runWaveAnimations(){
        runAtlasAnimation()
    }
    
    // TODO send the atlases, and the nodes
    func runAtlasAnimation() {
        waveLarge.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesLarge, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWave1")
    }
    
    
    
    
    
    func walkingSound() {
        runAction(walkSound, withKey: "walkingSound")
    }
    
    
    
    
    
    
    /* Whenevr the hero touches a darkrainbow the death function will be executed*/
    func didBeginContactBlackRainbow(contact: SKPhysicsContact) {
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
        
        background.anchorPoint = CGPointMake(0.5, 0)
        
        background.size.width = self.frame.size.width
        background.size.height = self.frame.size.height
        background.position = CGPointMake(CGRectGetMidX(self.frame), 0)
        
        addChild(background)
    
    }
    
    
    // This will start running the wave loop
    func runWaveLarge() {
        waveLarge.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesLarge, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWave1")
    }
 
    
    
    override func didEvaluateActions()  {
        checkCollisions()
        
        
        
    }

    func checkCollisions(){
        
        // TODO don't check collision for rainbows with alpha < 1
        var blackHitRainbows: [SKSpriteNode] = []
        enumerateChildNodesWithName(RainbowsType.Black.rawValue) { node, _ in
            let rainbow = node as SKSpriteNode
            if CGRectIntersectsRect(rainbow.frame, self.hero.frame) && rainbow.alpha >= 1 {
                blackHitRainbows.append(rainbow)
            }
        }
        for rainbow in blackHitRainbows {
           
            // Do whatever you want with every single collision
            
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
            
        }
        
        // println("---- blackHitRainbows \(blackHitRainbows)")
        // println("---- normalHitRainbows \(normalHitRainbows)")
        
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
    
    
    
    // whenever a player lets go of a side of the screen the player stops moving
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if touches.count >= 2 {
            
            var direction:String = determineDirection(touches)
            moveHero(direction)
            
        }else{
            
            cancelHeroMoves()
            removeActionForKey("walkingSound")
            
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
    }
    
    
    /* this should be fired when another touch happen */
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var direction:String = determineDirection(touches)
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
            let width = self.frame.size.width
            let random = Int(arc4random_uniform(UInt32(positions.count)))
            
            println("the \(texture.description) rainbow will be positioned at index \(random)")
            
            if rainbows.count == 0 {
                
                positionX = CGFloat(positions[random])// CGFloat.random(min: -width + texture.size().width, max: width - (distance * 3))
                current = Rainbow(position: CGPoint(x: positionX, y: texture.size().height + (frame.height / 2)), texture: texture, index: rainbows.count)
                
                rainbows.insert(current, atIndex: 0)
                
            }else{
                
                let lastRainbow:Rainbow = rainbows.first!
                var min = lastRainbow.position.x + distance
                var max = width - distance
                
                if(min > max || (min + distance > max)){
                    
                    min  = CGFloat.random(min: -width/2, max: lastRainbow.position.x)
                    
                }
                
                positionX = CGFloat(positions[random])// CGFloat.random(min: min, max: max)
                current = Rainbow(position: CGPoint(x: positionX, y:  texture.size().height + (frame.height / 2)), texture: texture, index: rainbows.count)
                
                rainbows.insert(current, atIndex: 0)
            }
            
            delayer = 0
            
            current.name = spriteName
            current.currentTarget = floor
            
            addChild(current)
            
        }
        
        delayer++
    }
    
    
    
    
    
    
    func moveAndCheckRainbows(){
        var abs:CGFloat, found: Int?
        let timeInterval:NSTimeInterval = 0.35
        
     //   let floorY =
        
        for rainbow:Rainbow in rainbows{
            
            rainbow.position.y -= CGFloat(Rainbows.Speed.rawValue)
            abs = rainbow.position.y
            
            rainbow.update()
           
            // TODO instead of an hardcoded value calculate the Y of the floor
            if abs < hero.position.y {
                
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
    
    
    
    override func update(currentTime: NSTimeInterval) {
        updateHeroPosition()
        
        if  self.floor.position.x == maxBarX {
            
            self.floor.position.x = self.origRunningFloorPositionXPoint
        }
        
        
        // Hero position
        
            
            //self.hero.position.y = self.heroBaseline
            //self.onGround = true
        
        
        
        
        
        
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

