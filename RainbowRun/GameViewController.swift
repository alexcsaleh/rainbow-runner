//
//  GameViewController.swift
//  RainbowRun
//
//  Created by Alexander Saleh on 4/1/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//




import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    
    
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView: SKView = self.view as SKView
            skView.showsFPS = false
            
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            // scene.anchorPoint = CGPointMake(CGRectGetMidX(GameScene().frame), CGRectGetMidY(GameScene().frame))
            scene.size = skView.bounds.size
            skView.presentScene(scene)
            var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music1", ofType: "caf")!)
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
            AVAudioSession.sharedInstance().setActive(true, error: nil)
            
            var error:NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
            audioPlayer.prepareToPlay()
            //audioPlayer.play()
            
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
