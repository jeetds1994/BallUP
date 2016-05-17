//
//  intialViewController.swift
//  BallUP
//
//  Created by Diljeet Singh on 4/27/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
// credit: http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift

import UIKit
import CoreData
import SpriteKit

class intialViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var internetConnectionLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var highScoreButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let saveName = NSUserDefaults.standardUserDefaults()

    @IBAction func playButton(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    @IBAction func howToPlayButton(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    
    @IBAction func highScoreButton(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    @IBAction func settingButton(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveName.valueForKey("name") == nil{
        nameTextField.text = "Insert Name!"
        }else{
        nameTextField.text = saveName.valueForKey("name") as! String
        }
 
        self.hideKeyboardWhenTappedAround()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        nameTextField.delegate = self

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        welcomeLabel.adjustsFontSizeToFitWidth = true
        playButton.titleLabel!.adjustsFontSizeToFitWidth = true
        howToPlayButton.titleLabel!.adjustsFontSizeToFitWidth = true
        highScoreButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        if Reachability.isConnectedToNetwork() == true {
            internetConnectionLabel.text = "Internet Connection: ✅"
            internetConnectionLabel.sizeToFit()
            
        } else {
            internetConnectionLabel.text = "Internet Connection: ❌"
            internetConnectionLabel.sizeToFit()
            activityIndicator.stopAnimating()
        }


        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        let fetchRequestLong = NSFetchRequest(entityName: "HighScore")
        
        do {
            
            let results = try managedContext?.executeFetchRequest(fetchRequestLong) as! AnyObject
            
            let savedData = results as! [AnyObject]
            
            activityIndicator.stopAnimating()
            
            for index in savedData{
                
                if Int32((index.valueForKeyPath("HighScore")?.description)!) > GameScene.highScore{
                    
                    let newhigh = Int32((index.valueForKeyPath("HighScore")?.description)!)
                    let recID = (index.valueForKeyPath("recordID")?.description)!
                    GameScene.recordID = recID
                    GameScene.highScore = newhigh!
                }
            }
            
        }catch let error as NSError{
            activityIndicator.stopAnimating()
            GameScene().alert("Unable to fetch data from Cloud", message: "Could be a connection issue or may need to signin to iCloud.", button: "Ok")
            print("Could not fetch \(error), \(error.userInfo)")
        }
 
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
 
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
            var name = nameTextField.text
            if nameTextField.text == "" {
            nameTextField.text = "Insert Name!"
            }
            saveName.setValue(name, forKey: "name")
            nameTextField.sizeToFit()
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

}