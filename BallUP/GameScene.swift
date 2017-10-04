//
//  GameScene.swift
//  BallUP
//
//  Created by Diljeet Singh on 3/13/16.
//  Copyright (c) 2016 Diljeet Singh. All rights reserved.


// credit to https://www.youtube.com/channel/UCDIBBmkZIB2hjBsk1hUImdA
// credit to Jarded Davidson for his awesome Youtube Videos
//

import SpriteKit
import CoreMotion
import CoreData
import CloudKit
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


struct PhysicsCatagory {
    static let Ball: UInt32 = 0x1 << 1
    static let BottomWall : UInt32 = 0x1 << 2
    static let Wall: UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

@objc protocol GameOverDelegate {
    func gameOverDelegateFunc()
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gamescene_delegate : GameOverDelegate?
    
    var wave = 1
    
    var Ball = SKSpriteNode()
    
    var manager = CMMotionManager()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int32()
    
    let tap2BeginLabel = SKLabelNode()
    
    let scoreLabel = SKLabelNode()
    
    var bottomBorder = SKSpriteNode()
    
    var topBorder = SKSpriteNode()
    
    var died = Bool()
    
    var restartButton = SKSpriteNode()
    
    var BackButton = SKSpriteNode()
    
    var spawnDelay = SKAction()
    
    var spawn = SKAction()
    
    static var highScore = Int32()
    
    var highScoreLabel = SKLabelNode()
    
    var container = CKContainer.default()
    
    var publicDatabase: CKDatabase?
    
    var wasScoreFectched = Bool()
    
    static var recordID = String()
    
    var saveCounter = 0
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTwoFingerTap))
        doubleTap.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(doubleTap)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        let fetchRequestLong = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        
        do {
            
            let results = try managedContext?.fetch(fetchRequestLong) as AnyObject
            
            let savedData = results as! [AnyObject]
            
            for index in savedData{
                
                if Int32(((index.value(forKeyPath: "HighScore") as AnyObject).description)!) > GameScene.highScore{

                    let newhigh = Int32(((index.value(forKeyPath: "HighScore") as AnyObject).description)!)
                    let recID = ((index.value(forKeyPath: "recordID") as AnyObject).description)!
                    
                    GameScene.recordID = recID
                    GameScene.highScore = newhigh!
                }
            }
            
        }catch let error as NSError{
            
            print("Could not fetch \(error), \(error.userInfo)")}
        
        publicDatabase = container.publicCloudDatabase
        
//        if Reachability.isConnectedToNetwork() == true{
//        
//        if GameScene.recordID != "" {
//        
//        let recordIDwithName = CKRecordID(recordName: GameScene.recordID)
//        publicDatabase?.fetch(withRecordID: recordIDwithName, completionHandler: { (record, error) in
//            
//            if record == nil{
//                
//            self.alert("Unable to retrieve high Score from iCloud ", message: "Check Connection and make sure you are signed in to iCloud", button: "Ok")
//            
//            }else{
//            
//            let highestCloudScore = Int32(((record?.value(forKeyPath: "currentScore") as AnyObject).description)!)
//            
//            if GameScene.highScore < highestCloudScore{
//            GameScene.highScore = highestCloudScore!
//            }
//            
//            
//            }})
//        }}
//        
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        spawn = SKAction.run({
            () in
            self.createWalls()
        })
        
        if gameStarted == false{

            gameStarted = true
            Ball.physicsBody?.affectedByGravity = true

            let delay = SKAction.wait(forDuration: 2.0)
            
            spawnDelay = SKAction.sequence([spawn, delay])
            
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            
            self.run(spawnDelayForever, withKey: "firstTenWalls")
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            
            let moveWalls = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.01 * distance))
            
            let removeWalls = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
            
            // Moves Ball
            Ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 45))
            
            if died == false{
            
            manager.startAccelerometerUpdates()
            manager.accelerometerUpdateInterval = 0.1
            manager.startAccelerometerUpdates(to: OperationQueue.main){
                (data, error) in
                
                self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 10, dy: -12)
                //changing the number higher will result in moving the ball moving signficantly faster along the y axis.
            }}
            
        }else{
            if died == true {
            manager.stopAccelerometerUpdates()
            OperationQueue.main.isSuspended = true
            }else{
            // Moves Ball
            Ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 45))
            }
            
            if score > 10 && wave == 1{
                walls(1.8, key: "secondTenWalls", key2Stop: "firstTenWalls", waveNumber: 2)
                wallPair.removeAllChildren()
                print("score is greater than 10")
            }else if score > 20 && wave == 2 {
                walls(1.6, key: "thirdTenWalls", key2Stop: "secondTenWalls", waveNumber: 3)
                wallPair.removeAllChildren()
                print("score is greater than 20")
            }else if score > 30 && wave == 3 {
                walls(1.4, key: "fourthTenWalls", key2Stop: "thirdTenWalls", waveNumber: 4)
                //wallPair.removeAllChildren()
                print("score is greater than 30")
            }
            else if score > 40 && wave == 4 {
                walls(1.2, key: "fifthTenWalls", key2Stop: "fourthTenWalls", waveNumber: 5)
                wallPair.removeAllChildren()
                print("score is greater than 40")
            }
        }
     
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
                
                if restartButton.contains(location){
                    restartScene()
                }
                if BackButton.contains(location){
                    
                    print("BackButton")
                   /*
                    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var vc = mainStoryboard.instantiateViewControllerWithIdentifier("intialViewController") as! UIViewController
                    */
                    //view!.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                    //let vc = GameViewController()
                    //vc.GameOver()
                    gamescene_delegate?.gameOverDelegateFunc()
                }
            }
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func walls(_ time: TimeInterval, key: String, key2Stop: String, waveNumber: Int){
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        
        let moveWalls = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.01 * distance))
        
        let removeWalls = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
        
        wave = waveNumber
        spawn = SKAction.run({
        
            () in
            self.removeAction(forKey: key2Stop)
            
            self.createWalls()
        })
        
        let delay = SKAction.wait(forDuration: time)
        
        spawnDelay = SKAction.sequence([spawn, delay])
        
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        
        self.run(spawnDelayForever, withKey: key)
        /*
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        
        let moveWalls = SKAction.moveByX(0, y: -distance, duration: NSTimeInterval(0.01 * distance))
        
        let removeWalls = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
        */
    }
    
    func createScene(){
        
        self.physicsWorld.contactDelegate = self
        
        topBorder = SKSpriteNode(imageNamed: "Wall")
        topBorder.setScale(0.50)
        topBorder.zRotation = CGFloat(M_PI / 2)
        topBorder.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: topBorder.size)
        topBorder.physicsBody?.isDynamic = false
        
        self.addChild(topBorder)
        
        bottomBorder = SKSpriteNode(imageNamed: "Wall")
        bottomBorder.setScale(0.5)
        bottomBorder.zRotation = CGFloat(M_PI / 2)
        bottomBorder.position = CGPoint(x: self.frame.width / 2, y: 0 + bottomBorder.frame.height / 2)
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: bottomBorder.size)
        bottomBorder.physicsBody?.categoryBitMask = PhysicsCatagory.BottomWall
        bottomBorder.physicsBody?.collisionBitMask = PhysicsCatagory.Ball
        bottomBorder.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        bottomBorder.physicsBody?.affectedByGravity = false
        bottomBorder.physicsBody?.isDynamic = false
        bottomBorder.zPosition = 3
        
        self.addChild(bottomBorder)
        
        scoreLabel.position = CGPoint(x: self.frame.width / 2 , y: (self.frame.height / 4) + (self.frame.height / 2))
        scoreLabel.text = "\(score)"
        scoreLabel.isHidden = true
        self.addChild(scoreLabel)
        
        
        Ball = SKSpriteNode(imageNamed: "Ball")
        Ball.setScale(0.5)
        Ball.position = CGPoint(x: self.frame.width / 2, y: 200)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: Ball.frame.height / 2)
        Ball.physicsBody?.categoryBitMask = PhysicsCatagory.Ball
        Ball.physicsBody?.collisionBitMask = PhysicsCatagory.Wall | PhysicsCatagory.BottomWall
        Ball.physicsBody?.contactTestBitMask = PhysicsCatagory.Score | PhysicsCatagory.BottomWall | PhysicsCatagory.Wall
        Ball.physicsBody?.affectedByGravity = false
        Ball.zPosition = 2
        
        self.addChild(Ball)
        
        let leftBorder = SKSpriteNode(imageNamed: "Wall")
        leftBorder.setScale(1)
        leftBorder.position = CGPoint(x: 270, y: self.frame.height / 2)
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: leftBorder.size)
        leftBorder.physicsBody?.isDynamic = false
        
        self.addChild(leftBorder)
        
        let rightBorder = SKSpriteNode(imageNamed: "Wall")
        rightBorder.setScale(1)
        rightBorder.position = CGPoint(x: 760, y: self.frame.height / 2)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: rightBorder.size)
        rightBorder.physicsBody?.isDynamic = false
        
        self.addChild(rightBorder)
        
        tap2BeginLabel.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 4) + self.frame.height / 2)
        tap2BeginLabel.text = "Tap to Start Game!"
        
        addChild(tap2BeginLabel)
        
        highScoreLabel.position = CGPoint(x: (self.frame.width / 2), y: (self.frame.height / 4) + self.frame.height / 2 + 100)
        highScoreLabel.text = "HighScore is \(GameScene.highScore)"
        
        addChild(highScoreLabel)
        
        highScoreLabel.isHidden = true
        
    }
    
    func createWalls(){
        
        tap2BeginLabel.isHidden = true
        scoreLabel.isHidden = false
        
        wallPair = SKNode()
        
        let leftWall = SKSpriteNode(imageNamed: "Wall")
        let rightWall = SKSpriteNode(imageNamed: "Wall")
        
        
        
        
        //Positon
        leftWall.position = CGPoint(x: (self.frame.width / 4) - 25, y: self.frame.height - 50)
        rightWall.position = CGPoint(x: (self.frame.width - (self.frame.width / 4)) + 25, y: self.frame.height - 50)
        
        //Scale
        leftWall.setScale(0.50)
        rightWall.setScale(0.50)
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        
        //Gravity
        leftWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.affectedByGravity = false
        
        //Rotation
        leftWall.zRotation = CGFloat(M_PI / 2)
        rightWall.zRotation = CGFloat(M_PI / 2)
        
        leftWall.physicsBody?.collisionBitMask = PhysicsCatagory.Wall
        rightWall.physicsBody?.collisionBitMask = PhysicsCatagory.Wall
        
        //Dynamic makes objects fixed in position and not affected by collison.
        leftWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.isDynamic = false
        
        wallPair.addChild(leftWall)
        wallPair.addChild(rightWall)
        
        let scoreNode = SKSpriteNode()
        
        scoreNode.size = CGSize(width: 1000, height: 3)
        scoreNode.position = CGPoint(x: leftWall.position.x, y: leftWall.position.y)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ball
        scoreNode.color = SKColor.blue
        
        let randomPosition = CGFloat.random(min: -175, max: 175)
        
        wallPair.position.x = wallPair.position.x + randomPosition
        
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    func createRestartButton(){
    //restartButton = SKSpriteNode(color: SKColor.darkGrayColor(), size: CGSize(width: 200, height: 100))
    restartButton = SKSpriteNode(imageNamed: "RestartButton")
    restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 )
    restartButton.zPosition = 10
    self.addChild(restartButton)
    }
    
    func createBackButton(){
    BackButton = SKSpriteNode(imageNamed: "BackButton")
    //BackButton = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 100, height: 50))
    BackButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 100 )
    BackButton.zPosition = 10
    self.addChild(BackButton)
        
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ball || firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.Score{
            
            if died == false{
                score += 1
                scoreLabel.text = "\(score)"
            }
        }
        if died == false {
        if firstBody.categoryBitMask == PhysicsCatagory.BottomWall && secondBody.categoryBitMask == PhysicsCatagory.Ball || firstBody.categoryBitMask == PhysicsCatagory.Ball && secondBody.categoryBitMask == PhysicsCatagory.BottomWall {
            
            if score > GameScene.highScore {
            GameScene.highScore = score
            highScoreLabel.text = "HighScore is \(GameScene.highScore)"
            highScoreLabel.isHidden = false
            }else{
            highScoreLabel.isHidden = false
            }
            
            var counter = 0
            if counter == 0{
            died = true
            self.removeAllActions()
            wave = 1
            save()
            createRestartButton()
            createBackButton()
            counter += 1
            }}
        }
    }
    
    func restartScene(){
    
        self.removeAllChildren()
        self.removeAllActions()
        gameStarted = false
        died = false
        score = 0
        createScene()
        tap2BeginLabel.isHidden = false
        
    }
    
    func alert(_ title: String, message: String, button: String){
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: button)
        alert.show()
    }
    
    func save(){
        
        addActivityIndicator()
        
        publicDatabase = container.publicCloudDatabase
        
        let myRecord = CKRecord(recordType: "Scores")
        myRecord.setObject(String(score) as CKRecordValue, forKey: "currentScore")
        
        publicDatabase!.save(myRecord, completionHandler:
            ({returnRecord, error in
                if let err = error {
                    self.removeActivityIndicator()
                    print("Error in save2Cloud func, no internet connection, or iCloud is not signed in.")
                    if self.saveCounter == 0{
                        DispatchQueue.main.async {
                        self.alert("Unable to save score on iCloud", message: "Please Sign-in", button: "OK")}
                        self.saveCounter += 1
                        //Save Counter will prevent a alert every time the user dies within the game and will only notify them once.
            }} else {
                    
                    DispatchQueue.main.async {
                        
                    let recordName2Save = returnRecord?.recordID.recordName
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                        let managedContext = appDelegate?.managedObjectContext
                    
                       HighScore(highScore: self.score, recordID: recordName2Save!, context: managedContext!)
                        
                        do {
                            try managedContext?.save()
                            self.removeActivityIndicator()
                            print("save2Cloud Success")
                        } catch {
                            self.alert("Unable to save data to Cloud", message: "Could be a connection issue or may need to signin to iCloud.", button: "Ok")
                            self.removeActivityIndicator()
                            let saveError = error as NSError
                            print(saveError)
                        }
                    }
                }
        }))
    }
    
    func handleTwoFingerTap() {
        
        var isGamePaused = Bool()
        if view?.isPaused == false{
        isGamePaused = true
        view?.isPaused = true
        }else{
        view?.isPaused = false
        isGamePaused = false
        }
        
    }
    
    func addActivityIndicator(){
        DispatchQueue.main.async {
        self.activityIndicator.center = CGPoint(x: (self.view?.center.x)! , y: (self.view?.center.y)! + ((self.view?.center.y)! / 2))
        self.activityIndicator.startAnimating()
        self.view!.addSubview(self.activityIndicator)}
    }
    
    func removeActivityIndicator(){
        DispatchQueue.main.async {
        self.activityIndicator.removeFromSuperview()}
    }
}
