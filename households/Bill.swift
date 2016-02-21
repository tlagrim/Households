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
    @NSManaged var total_amount: Int
    @NSManaged var date_due: NSDate
    @NSManaged var remaining_amount: Int
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
    
    init(creator: PFUser, household: PFObject, is_complete: Bool, desc: String, total_amount: Int,  date_due: NSDate, remaining_amount: Int) {
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
    /*
    override class func query() -> PFQuery? {
    let bill = PFQuery(className: Bill())
    bill.includeKey("creator")
    bill.orderByAscending("updatedAt")
    return query
    }*/
    
    
    
}