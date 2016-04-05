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
    @IBOutlet weak var theHouseholdContainer: UIView!
    @IBOutlet weak var theJustMeContainer: UIView!
    @IBOutlet weak var monthyDuesLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var incompleteLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var nameBillPressedLabel: UILabel!
    @IBOutlet weak var amtBillPressedLabel: UILabel!
    
    
    /*
    
    var existingHouseholdBills: [PFObject] = []
    var existingJustMeBills: [PFObject] = []
    var existingHouseholdPayments: [PFObject] = []
    var existingJustMePayments: [PFObject] = []
    
    */
    
    var householdBillTotal: Double = 0
    var justMePaymentTotal: Double = 0
    override func viewDidLoad() {
        initializeView(0)
        
        // print("Class: BillViewController\nViewDidLoad()")
        if self.revealViewController() != nil {
            openMenu.target = self.revealViewController()
            openMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        theHouseholdContainer.hidden = false
        theJustMeContainer.hidden = true
        
    }
    
    func initializeView(theSwitch: Int) {
        justMePaymentTotal = 0
        householdBillTotal = 0
        if theSwitch == 0 {
            for aHouseholdBill in existingHouseholdBills {
                householdBillTotal += Double((aHouseholdBill.objectForKey("remaining_amount")?.description)!)!
            }
            self.monthyDuesLabel.text = String(householdBillTotal)
        }
        if theSwitch == 1 {
            for aJustMePayment in existingJustMePayments {
                justMePaymentTotal += Double((aJustMePayment.objectForKey("amount")?.description)!)!
            }
            self.monthyDuesLabel.text = String(justMePaymentTotal)
        }
    }
    
    @IBAction func createNewBillPressed(sender: AnyObject) {
        print("CreateNewBill button pressed")
        
    }
    @IBAction func justMeButton(sender: AnyObject) {
        print("Just me tab/button pressed")
        theHouseholdContainer.hidden = true
        theJustMeContainer.hidden = false
        initializeView(1)
    }
    
    @IBAction func householdButton(sender: AnyObject) {
        print("Household tab/button pressed")
        theJustMeContainer.hidden = true
        theHouseholdContainer.hidden = false
        initializeView(0)
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