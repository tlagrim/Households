//
//  Grocery.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import Foundation
import UIKit

class Grocery: PFObject, PFSubclassing {
    @NSManaged var creator: PFUser
    @NSManaged var name: String?
    @NSManaged var price: Double
    @NSManaged var brand_name: String?
    @NSManaged var store: String?
    @NSManaged var detail: String?
    @NSManaged var image: PFFile
    
    
    class func parseClassName() -> String {
        return "Grocery" // set the name of the clss as seen in the database
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(creator: PFUser, name: String?, price: Double, brand_name: String?, store: String?, detail: String?, image: PFFile) {
        super.init()
        self.creator = creator
        self.name = name
        self.price = price
        self.brand_name = brand_name
        self.store = store
        self.detail = detail
        self.image = image
    }
    
    override init() {
        super.init()
    }
    /*
    override class func query() -> PFQuery? {
        let grocery = PFQuery(className: Grocery.parseClassName())
        grocery.includeKey("creator")
        grocery.orderByAscending("updatedAt")
        return query
    }*/
    
    
    
}