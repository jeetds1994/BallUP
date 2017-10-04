//
//  RecentScores.swift
//  BallUP
//
//  Created by Diljeet Singh on 4/13/16.
//  Copyright © 2016 Diljeet Singh. All rights reserved.
//

import Foundation
import CoreData

@objc(RecentScores)

class RecentScores: NSManagedObject {
    
    @NSManaged var firstScore: Int32
    @NSManaged var secondScore: Int32
    @NSManaged var thirdScore: Int32
    @NSManaged var fourthScore: Int32
    @NSManaged var fifthScore: Int32

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init (pin: String, photoid: String, photourl: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: "RecentScores", in: context)
        
        super.init(entity: entity!, insertInto: context)
        
    }
    
}
