//
//  HouseholdsGlobal.swift
//  Households
//
//  Created by TJ Lagrimas on 3/7/16.
//
//

import Foundation

// For the case where there is no internet connection
//  For every user that has signed into this device,
//  securely save all their information including username
//  and password so that they may be able to sign in and edit
//  how they like.

var existingHouseholds:[PFObject] = []
var existingOccupancies:[PFObject] = []
var existingUsers:[PFUser] = []
var existingUsersInActiveOccupancy:[PFUser] = []
var existingBills:[PFObject] = []
var existingPayments: [PFObject] = []


var existingHouseholdBills: [PFObject] = []
var existingJustMeBills: [PFObject] = []
var existingHouseholdPayments: [PFObject] = []
var existingJustMePayments: [PFObject] = []

struct GlobalInitializers {
    
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
    
    func createUsersInActiveOccupancy() {
        existingUsersInActiveOccupancy = []
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.includeKey("occupant")
        occupancyQuery.includeKey("household")
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.whereKey("occupant", equalTo: PFUser.currentUser()!)
        let userQuery = PFUser.query()
        let householdQuery = PFQuery(className: Household.parseClassName())
        
        
        let allOccupanciesQuery = PFQuery(className: Occupy.parseClassName())
        allOccupanciesQuery.includeKey("occupant")
        allOccupanciesQuery.includeKey("household")
        
        occupancyQuery.findObjectsInBackgroundWithBlock { (theOccupant, error) -> Void in
            if error == nil {
                for currentOccupant in theOccupant! {
                allOccupanciesQuery.findObjectsInBackgroundWithBlock { (allOccupants, error) -> Void in
                    if error == nil {
                        for thisOccupant in allOccupants! {
                            if thisOccupant.objectForKey("household") as! Household == currentOccupant.objectForKey("household") as! Household {
                                existingUsersInActiveOccupancy.append(thisOccupant.objectForKey("occupant") as! PFUser)
                            }
                        }
                    } else {
                        print("ERROR IN \'allOccupanciesQuery\'")
                    }
                }
                }
            } else {
                print("ERROR IN \'occupancyQuery\'")
            }
        }
    }
    
    func initializeExistingBills() {
        let existingBillsQuery = PFQuery(className: Bill.parseClassName())
        existingBillsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for billObject in objects! {
                    existingBills.append(billObject)
                    print("Loading Bill object: ", billObject)
                }
            } else {
                print("ERROR IN \'existingBillsQuery\'")
            }
        }
    }
    
    func initializeExistingPayments() {
        let existingPaymentQuery = PFQuery(className: Payment.parseClassName())
        existingPaymentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for paymentObject in objects! {
                    existingPayments.append(paymentObject)
                    print("Loading Payment object: ", paymentObject)
                }
            } else {
                print("ERROR IN \'existingPaymentQuery\'")
            }
        }
    }
    
    func filterBillForHousehold(occupancyId: String) {
        filterPaymentForHousehold(occupancyId)
        existingHouseholdBills = []
        for billItem in existingBills {
            // print("Bill: ",billItem.objectForKey("household")?.valueForKey("objectId"))
            if occupancyId == billItem.objectForKey("household")!.valueForKey("objectId")! as! String {
                // print("OccID: ", occupancyId)
                existingHouseholdBills.append(billItem)
            }
        }
    }
    
    func filterPaymentForHousehold(occupyId: String) {
        existingHouseholdPayments = []
        existingJustMePayments = []
        existingJustMeBills = []
        for paymentItem in existingPayments {
            if occupyId == paymentItem.objectForKey("household")?.valueForKey("objectId")! as! String {
                existingHouseholdPayments.append(paymentItem)
                if PFUser.currentUser() == (paymentItem.objectForKey("contributor") as! PFUser) {
                    existingJustMePayments.append(paymentItem)
                    existingJustMeBills.append(paymentItem.objectForKey("bill") as! PFObject)
                }
            }
        }
    }
    
    
    
}