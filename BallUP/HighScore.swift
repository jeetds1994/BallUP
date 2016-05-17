//
//  HighScore.swift
//  BallUP
//
//  Created by Diljeet Singh on 4/13/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//

import CoreData

@objc(HighScore)

class HighScore: NSManagedObject {
    @NSManaged var highScore: Int32
    @NSManaged var recordID : String
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init (highScore: Int32, recordID: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName("HighScore", inManagedObjectContext: context)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.highScore = highScore
        self.recordID = recordID
    }
    
    
}
