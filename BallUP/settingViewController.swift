//
//  settingViewController.swift
//  BallUP
//
//  Created by Diljeet Singh on 5/8/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//

import UIKit
import SpriteKit

class settingViewController: UIViewController {

    
    @IBOutlet weak var backgroundColorSelected: UISegmentedControl!
    
    
    override func viewDidLoad() {
        backgroundColorSelected.selectedSegmentIndex = GameViewController.gameBackground
        backgroundColorSelected.setTitle("Green", forSegmentAt: 0)
        backgroundColorSelected.setTitle("Brown", forSegmentAt: 1)
        backgroundColorSelected.setTitle("Gray", forSegmentAt: 2)
        backgroundColorSelected.setTitle("Red", forSegmentAt: 3)
    }
    
    @IBAction func backgroundColorSegment(_ sender: AnyObject) {
        
        if backgroundColorSelected.selectedSegmentIndex == 0 {
            GameViewController.gameBackground = 0
            print("Green")
        }
        
        if backgroundColorSelected.selectedSegmentIndex == 1 {
            GameViewController.gameBackground = 1
            print("Brown")
        }
        
        if backgroundColorSelected.selectedSegmentIndex == 2 {
            GameViewController.gameBackground = 2
            print("Gray")
            
        }
        
        if backgroundColorSelected.selectedSegmentIndex == 3 {
            GameViewController.gameBackground = 3
            print("Red")
            
        }
    }
}
