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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class intialViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var internetConnectionLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var highScoreButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let saveName = UserDefaults.standard

    @IBAction func playButton(_ sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    @IBAction func howToPlayButton(_ sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    
    @IBAction func highScoreButton(_ sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    @IBAction func settingButton(_ sender: AnyObject) {
    nameTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveName.value(forKey: "name") == nil{
        nameTextField.text = "Insert Name!"
        }else{
        nameTextField.text = saveName.value(forKey: "name") as! String
        }
 
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(intialViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(intialViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        nameTextField.delegate = self

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        welcomeLabel.adjustsFontSizeToFitWidth = true
        playButton.titleLabel!.adjustsFontSizeToFitWidth = true
        howToPlayButton.titleLabel!.adjustsFontSizeToFitWidth = true
        highScoreButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
//        if Reachability.isConnectedToNetwork() == true {
//            internetConnectionLabel.text = "Internet Connection: ✅"
//            internetConnectionLabel.sizeToFit()
//            
//        } else {
//            internetConnectionLabel.text = "Internet Connection: ❌"
//            internetConnectionLabel.sizeToFit()
//            activityIndicator.stopAnimating()
//        }


        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        let fetchRequestLong = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        
        do {
            
            let results = try managedContext?.fetch(fetchRequestLong) as AnyObject
            
            let savedData = results as! [AnyObject]
            
            activityIndicator.stopAnimating()
            
            for index in savedData{
                
                if Int32(((index.value(forKeyPath: "HighScore") as AnyObject).description)!) > GameScene.highScore{
                    
                    let newhigh = Int32(((index.value(forKeyPath: "HighScore") as AnyObject).description)!)
                    let recID = ((index.value(forKeyPath: "recordID") as AnyObject).description)!
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
 
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
            let name = nameTextField.text
            if nameTextField.text == "" {
            nameTextField.text = "Insert Name!"
            }
            saveName.setValue(name, forKey: "name")
            nameTextField.sizeToFit()
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(intialViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
