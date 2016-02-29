//
//  Assignment.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation

class Assignment: PFObject, PFSubclassing {
    @NSManaged var chore: PFObject
    @NSManaged var household: PFObject
    @NSManaged var assigned_to: PFUser
    @NSManaged var assignment_creator: PFUser
    @NSManaged var message: String?
    @NSManaged var is_complete: Bool
    /* add more here
    @NSManaged var is_complete: Bool
    @NSManaged var is_repeat: Bool
    @NSManaged var date_due: NSDate
    */
    
    
    // 1. Table view delegate methods here
    class func parseClassName() -> String {
        //print("Class: Assignment\nparseClassName()\nreturn\"Assignment\"")
        return "Assignment" // set the name of the class as seen in the database
    }
    
    // 2. Let Parse know that you intend to use this subclass for all objects
    // with class type Group. You want to do this only once, so you’re
    // using dispatch_once_t to make sure of that.
    override class func initialize() {
        //print("Class: Assignment\ninitialize()\nreturn\"self.registerSubclass()\"")
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(chore: PFObject, household: PFObject, assigned_to: PFUser, assignment_creator: PFUser, message: String?, is_complete: Bool) {
        super.init()
        //print("Class: Occupy\ninit()\nself...")
        self.chore = chore
        self.household = household
        self.assigned_to = assigned_to
        self.assignment_creator = assignment_creator
        self.message = message
        self.is_complete = is_complete
    }
    
    override init() {
        //print("in ovveride super.init()")
        super.init()
    }
    
    
    //get tha occupancy
    override class func query() -> PFQuery? {
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        let assignmentQuery = PFQuery(className: Assignment.parseClassName())
        
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        
        assignmentQuery.includeKey("chore")
        assignmentQuery.includeKey("household")
        assignmentQuery.includeKey("assigned_to")
        assignmentQuery.includeKey("assignment_creator")
        // assignmentQuery.whereKey("household", matchesKey: "is_active_occupancy", inQuery: occupancyQuery)
        assignmentQuery.whereKey("household", matchesKey: "household", inQuery: occupancyQuery)
        
        /*
        let user = PFUser.currentUser()
        let assignment = PFQuery(className: Assignment.parseClassName())
        let query = PFQuery(className: Occupy.parseClassName())
        
        query.whereKey("occupant", equalTo: user!)
        
        assignment.includeKey("chore")
        assignment.includeKey("household")
        assignment.includeKey("assigned_to")
        assignment.includeKey("assignment_creator")
        assignment.whereKey("household", matchesKey: "household", inQuery: query)
        */
        //print("querying in Assignment")
        return assignmentQuery
    }
}