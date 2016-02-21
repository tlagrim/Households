//
//  Occupancy.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation

class Occupy: PFObject, PFSubclassing {
    @NSManaged var occupant: PFUser
    @NSManaged var household: PFObject
    
    // 1. Table view delegate methods here
    class func parseClassName() -> String {
        print("Class: Occupy\nparseClassName()\nreturn\"Occupy\"")
        return "Occupy" // set the name of the class as seen in the database
    }
    
    // 2. Let Parse know that you intend to use this subclass for all objects
    // with class type Group. You want to do this only once, so you’re
    // using dispatch_once_t to make sure of that.
    override class func initialize() {
        print("Class: Occupy\ninitialize()\nreturn\"self.registerSubclass()\"")
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(household: PFObject, occupant: PFUser) {
        super.init()
        print("Class: Occupy\ninit()\nself...")
        self.household = household
        self.occupant = occupant
        
    }
    
    override init() {
        print("in ovveride super.init()")
        super.init()
    }
    
    
    //get tha occupancy
    override class func query() -> PFQuery? {
        print("override class func query() -> PFQuery?")
        
        let user = PFUser.currentUser()
        
        // 1
        // Create a PFQuery object for the Occupy class.
        print("let query = PFQuery(className: Occupy())")
        let occupancy = PFQuery(className: Occupy.parseClassName())
        
        // 2
        // Request that this query will return the full occupant and household details.
        // Without this line of code, the query will just return the
        // object reference of the user without its details.
        print("query.includeKey(\"createdBy\")")
        occupancy.whereKey("occupant", equalTo: user!)

        // occupancy.includeKey("occupant")
        occupancy.includeKey("household")
        
        // 3
        // Sort the results by their creation date.
        print("query.orderByDescending(\"updatedAt\")")
        occupancy.orderByDescending("updatedAt")
        print("return query")
        
        
        return occupancy
    }
    
    
    
}