//
//  Bill.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation
import UIKit

class Bill: PFObject, PFSubclassing {
    @NSManaged var creator: PFUser
    @NSManaged var household: PFObject
    @NSManaged var is_complete: Bool
    @NSManaged var desc: String
    @NSManaged var total_amount: Double
    @NSManaged var date_due: NSDate
    @NSManaged var remaining_amount: Double
    // @NSManaged var logo: PFFile

    
    class func parseClassName() -> String {
        return "Bill" // set the name of the clss as seen in the database
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(creator: PFUser, household: PFObject, is_complete: Bool, desc: String, total_amount: Double,  date_due: NSDate, remaining_amount: Double) {
        super.init()
        self.creator = creator
        self.household = household
        self.is_complete = is_complete
        self.desc = desc
        self.total_amount = total_amount
        self.date_due = date_due
        self.remaining_amount = remaining_amount
    }
    
    override init() {
        super.init()
    }
    
    
    
    override class func query() -> PFQuery? {
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        let billQuery = PFQuery(className: Bill.parseClassName())
        
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        
        billQuery.includeKey("creator")
        billQuery.includeKey("household")
        // assignmentQuery.whereKey("household", matchesKey: "is_active_occupancy", inQuery: occupancyQuery)
        billQuery.whereKey("household", matchesKey: "household", inQuery: occupancyQuery)
        billQuery.orderByAscending("date_due")
        
        return billQuery
    }
    
    
    
}