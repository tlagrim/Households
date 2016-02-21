//
//  Listing.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import Foundation

class Listing: PFObject, PFSubclassing {
    @NSManaged var grocery_item: PFObject
    @NSManaged var household: PFObject
    @NSManaged var creator: PFUser
    @NSManaged var quantity: Int
    @NSManaged var priority: Int
    @NSManaged var detail: String?
    @NSManaged var is_private: Bool
    
    // 1. Table view delegate methods here
    class func parseClassName() -> String {
        print("Class: Listing\nparseClassName()\nreturn\"Listing\"")
        return "Listing" // set the name of the class as seen in the database
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
    
    init(grocery_item: PFObject, household: PFObject, creator: PFUser, quantity: Int, priority: Int, detail: String?, is_private: Bool) {
        super.init()
        print("Class: Listing\ninit()\nself...")
        self.grocery_item = grocery_item
        self.household = household
        self.creator = creator
        self.quantity = quantity
        self.priority = priority
        self.detail = detail
        self.is_private = is_private
    }
    
    override init() {
        print("Listing() in ovveride super.init()")
        super.init()
    }
    
    
    //get tha occupancy 
    /*
    override class func query() -> PFQuery? {
        
        let user = PFUser.currentUser()
        let listing = PFQuery(className: Listing.parseClassName())
        let query = PFQuery(className: Occupy.parseClassName())
        
        query.whereKey("occupant", equalTo: user!)
        
        listing.includeKey("grocery_item")
        listing.includeKey("household")
        listing.includeKey("creator")
        listing.whereKey("household", matchesKey: "household", inQuery: query)
        
        //print("querying in Assignment")
        return listing
    }*/
}