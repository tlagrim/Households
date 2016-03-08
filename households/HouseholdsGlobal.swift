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
    let existingHouseholdsQuery = PFQuery(className: Household.parseClassName())
    existingHouseholdsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        if error == nil {
            for householdObject in objects! {
                existingHouseholds.append(householdObject)
                print("Loading Household object: ", householdObject)
            }
        } else {
            print("ERROR IN \'existingHouseholdQuery\'")
        }
    }
    
    
    
}

