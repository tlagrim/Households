//
//  Household.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation

class Household: PFObject, PFSubclassing {
    @NSManaged var household_name: String?
    @NSManaged var household_image: PFFile
    @NSManaged var household_creator: PFUser
    @NSManaged var household_num_occupants: Int
    @NSManaged var household_type: String?
    @NSManaged var household_streetAddress: String?
    @NSManaged var household_city: String?
    @NSManaged var household_state: String?
    @NSManaged var household_country: String?
    @NSManaged var household_zip_code: Int
    @NSManaged var key: String?
    
    // 1. Table view delegate methods here
    class func parseClassName() -> String {
        print("Class: Household\nparseClassName()\nreturn\"Household\"")
        return "Household" // set the name of the clss as seen in the database
    }
    
    // 2. Let Parse know that you intend to use this subclass for all objects
    // with class type Group. You want to do this only once, so you’re
    // using dispatch_once_t to make sure of that.
    override class func initialize() {
        print("Class: Household\ninitialize()\nreturn\"self.registerSubclass()\"")
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(name: String?, image: PFFile, creator: PFUser, numOccupants: Int, type: String?, streetAddress: String?, city: String?, state: String?, zip: Int, country: String, key: String?) {
        super.init()
        print("Class: Household\ninit()\nself...")
        self.household_name = name
        self.household_image = image
        self.household_creator = creator
        self.household_num_occupants = numOccupants
        self.household_type = type
        self.household_streetAddress = streetAddress
        self.household_city = city
        self.household_state = state
        self.household_zip_code = zip
        self.household_country = country
        self.key = key
        
    }
    
    override init() {
        print("in ovveride super.init()")
        super.init()
    }
    
    
    //get tha households
    override class func query() -> PFQuery? {
        print("override class func query() -> PFQuery?")

        // 1
        // Create a PFQuery object for the Group class.
        print("let query = PFQuery(className: Household.parseClassName())")

        let query = PFQuery(className: Household.parseClassName())
        
        // 2
        // Request that this query will return the full user details.
        // Without this line of code, the query will just return the
        // object reference of the user without its details.
        print("query.includeKey(\"createdBy\")")
        query.includeKey("createdBy")
        
        // 3
        // Sort the results by their creation date.
        print("query.orderByDescending(\"updatedAt\")")
        query.orderByDescending("updatedAt")
        print("return query")
        return query
    }
    
    
    
}