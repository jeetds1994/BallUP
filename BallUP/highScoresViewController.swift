//
//  highScoresViewController.swift
//  BallUP
//
//  Created by Diljeet Singh on 4/27/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//

import UIKit

class highScoresViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var mockLabel: UILabel!
    
    override func viewDidLoad() {
        
        highScoreLabel.text = "\(GameScene.highScore)"
        
        mockLabel.text = "Thats your high score.....LOL"
        
    }
    
}
