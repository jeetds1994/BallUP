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
        
        navigationController?.isNavigationBarHidden = true

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            if GameViewController.gameBackground == 0 {
            print("orginal green color")
            }
            if GameViewController.gameBackground == 1 {
            scene.backgroundColor = SKColor.brown
            }
            if GameViewController.gameBackground == 2 {
            scene.backgroundColor = SKColor.gray
            }
            if GameViewController.gameBackground == 3 {
            scene.backgroundColor = SKColor.red
            }
            skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            scene.gamescene_delegate = self
            }
    }
    
    func gameOverDelegateFunc() {

        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
