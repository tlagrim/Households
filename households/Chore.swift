//
//  Chore.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation
import UIKit

class Chore: PFObject, PFSubclassing {
    @NSManaged var chore_title: String?
    @NSManaged var chore_image: PFFile
    
    class func parseClassName() -> String {
        return "Chore" // set the name of the clss as seen in the database
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(title: String?, image: PFFile) {
        super.init()
        self.chore_title = title
        self.chore_image = image
    }
    
    override init() {
        super.init()
    }
    
override class func query() -> PFQuery? {
        let chores = PFQuery(className: Chore.parseClassName())
        return query()
    }
    
    
    
}