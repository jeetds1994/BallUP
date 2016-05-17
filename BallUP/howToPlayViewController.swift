//
//  howToPlayViewController.swift
//  BallUP
//
//  Created by Diljeet Singh on 4/27/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//

import UIKit

class howToPlayViewController: UIViewController {
    
    @IBOutlet weak var controlsLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    
    override func viewDidLoad() {
        
        controlsLabel.text = "Tap the display to propel the ball in the upward direction. (Continuously tap to keep the ball level and to prevent the ball from dropping). Tilt the phone in the left and right ward motion to manuver left and right."
        controlsLabel.sizeToFit()
        controlsLabel.numberOfLines = 8
        
        objectiveLabel.text = "Navigate between the walls to collect a highscore. Tip: Every 10 points the game will get harder! ;) and Settings will allow you to change the color of the backgound of the game"
        
        objectiveLabel.numberOfLines = 8
    } 
}
