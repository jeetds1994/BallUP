//
//  GameViewController.swift
//  BallUP
//
//  Created by Diljeet Singh on 3/13/16.
//  Copyright (c) 2016 Diljeet Singh. All rights reserved.
//
// credit: http://stackoverflow.com/questions/28184461/how-to-call-method-from-viewcontroller-in-gamescene

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameOverDelegate {

    var skView = SKView()
    
    static var gameBackground = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            if GameViewController.gameBackground == 0 {
            print("orginal green color")
            }
            if GameViewController.gameBackground == 1 {
            scene.backgroundColor = SKColor.brownColor()
            }
            if GameViewController.gameBackground == 2 {
            scene.backgroundColor = SKColor.grayColor()
            }
            if GameViewController.gameBackground == 3 {
            scene.backgroundColor = SKColor.redColor()
            }
            skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            scene.gamescene_delegate = self
            }
    }
    
    func gameOverDelegateFunc() {

        navigationController?.popViewControllerAnimated(true)
        navigationController?.navigationBarHidden = false
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
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
