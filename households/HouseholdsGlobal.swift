//
//  HouseholdsGlobal.swift
//  Households
//
//  Created by TJ Lagrimas on 3/7/16.
//
//

import Foundation
var existingHouseholds:[PFObject] = []
var existingOccupancies:[PFObject] = []
var existingUsers:[PFUser] = []


func createAllExistingObjects() {
    let existingOccupanciesQuery = PFQuery(className: Occupy.parseClassName())
    existingOccupanciesQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        if error == nil {
            for occupyObject in objects! {
                existingOccupancies.append(occupyObject)
                print("Loading Occupy object: ", occupyObject.objectId)
            }
        } else {
            print("ERROR IN \'existingOccupanciesQuery\'")
        }
    }
    
    
    
}

