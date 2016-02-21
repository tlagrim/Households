//
//  BillParentViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation

class BillParentViewController: PFQueryTableViewController {
    
    // both objects are Occupy objects
    var currentOccupancy: PFObject?
    var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        var pVC = BillParentViewController()
        pVC.currentOccupancy = currentOccupancy
        
        super.viewDidLoad()
        if currentOccupancy == nil && currentOccupancy2 == nil {
            print("both are nil")
        } else if currentOccupancy == nil && currentOccupancy2 != nil{
            print ("1st is nil, 2nd is not nil")
            currentOccupancy = currentOccupancy2
        } else if currentOccupancy != nil && currentOccupancy2 == nil {
            print ("2nd is nil, 1st is not nil")
        } else {
            print("both are not nil")
            currentOccupancy = currentOccupancy2
        }
        
        let household = currentOccupancy?.objectForKey("household")
        let householdName = household?.valueForKey("household_name")
    
        self.title = "Bills"

    }

}