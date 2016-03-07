//
//  BillViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/29/16.
//
//

import Foundation
import UIKit


var justMeBillsValsArray: [Double] = []
var householdBillsValsArray: [Double] = []



class BillViewController: UIViewController {
    var switchToSend = 0 // just me
    
    @IBOutlet weak var theHouseholdContainer: UIView!
    @IBOutlet weak var theJustMeContainer: UIView!
    @IBOutlet weak var monthyDuesLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var incompleteLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var nameBillPressedLabel: UILabel!
    @IBOutlet weak var amtBillPressedLabel: UILabel!
    
    override func viewDidLoad() {
        print("Class: BillViewController\nViewDidLoad()")
        if self.revealViewController() != nil {
            openMenu.target = self.revealViewController()
            openMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        theHouseholdContainer.hidden = false
        theJustMeContainer.hidden = true
        // monthyDuesLabel.text = theCurrentOccupancyBillTotal.description
        //justMeBillsValsArray.reduce(0,combine: +)
        //householdBillsValsArray.reduce(0, combine: +)
    }
    
    @IBAction func createNewBillPressed(sender: AnyObject) {
        print("CreateNewBill button pressed")
        
    }
    @IBAction func justMeButton(sender: AnyObject) {
        print("Just me tab/button pressed")
        theHouseholdContainer.hidden = true
        theJustMeContainer.hidden = false
        switchToSend = 0
        
    }
    
    @IBAction func householdButton(sender: AnyObject) {
        print("Household tab/button pressed")
        theJustMeContainer.hidden = true
        theHouseholdContainer.hidden = false
        switchToSend = 1
    }
    
    @IBAction func sortByName(sender: AnyObject) {
        print("SortByName tab/button pressed")
    }
    
    @IBAction func sortByDate(sender: AnyObject) {
        print("SortByDate tab/button pressed")
    }
    
    @IBAction func sortByAmount(sender: AnyObject) {
        print("SortByAmount tab/button pressed")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "childBillJustMeSegue"){
            let childTVC = segue.destinationViewController as! JustMeBillTableViewController
            childTVC.theParentVC = self
        }
        if(segue.identifier == "childHouseholdBillSegue"){
            let childTVC = segue.destinationViewController as! HouseholdBillTableViewController
            childTVC.theParentVC = self
        }
    }
    
}