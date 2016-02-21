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

    // @NSManaged var logo: PFFile
    
    
    class func parseClassName() -> String {
        return "Payment" // set the name of the clss as seen in the database
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(bill: PFObject, contributor: PFUser, household: PFObject) {
        super.init()
        self.bill = bill
        self.contributor = contributor
        self.household = household
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