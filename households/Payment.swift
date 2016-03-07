//
//  Payment.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation
import UIKit

class Payment: PFObject, PFSubclassing {
    @NSManaged var bill: PFObject
    @NSManaged var contributor: PFUser
    @NSManaged var household: PFObject
    @NSManaged var is_complete: Bool
    @NSManaged var is_repeat: Bool
    @NSManaged var is_private: Bool
    @NSManaged var amount: Double
    @NSManaged var percentage: Double
    
    class func parseClassName() -> String {
        return "Payment" // set the name of the clss as seen in the database
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(bill: PFObject, contributor: PFUser, household: PFObject, is_complete: Bool, is_repeat: Bool, is_private: Bool, amount: Double, percentage: Double) {
        super.init()
        self.bill = bill
        self.contributor = contributor
        self.household = household
        self.is_complete = is_complete
        self.is_repeat = is_repeat
        self.is_private = is_private
        self.amount = amount
        self.percentage = percentage
    }
    
    override init() {
        super.init()
    }
    /*
    override class func query() -> PFQuery? {
    let payment = PFQuery(className: Payment())
    payment.includeKey("creator")
    payment.orderByAscending("updatedAt")
    return query
    }*/
    
    
    
}