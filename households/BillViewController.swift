//
//  BillViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/29/16.
//
//

import Foundation
import UIKit

class BillViewController: UIViewController {
    
    @IBOutlet weak var monthyDuesLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var incompleteLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!

    @IBOutlet weak var nameBillPressedLabel: UILabel!
    
    @IBOutlet weak var amtBillPressedLabel: UILabel!
    
    override func viewDidLoad() {
        print("Class: BillViewController\nViewDidLoad()")
        
    }
    
    @IBAction func createNewBillPressed(sender: AnyObject) {
        print("CreateNewBill button pressed")

    }
    @IBAction func justMeButton(sender: AnyObject) {
        print("Just me tab/button pressed")
    }
    
    @IBAction func householdButton(sender: AnyObject) {
        print("Household tab/button pressed")
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
        if segue.identifier == "childBillTableSegue"{
            let childTVC = segue.destinationViewController as! BillTableViewController
            childTVC.theParentVC = self
        }
    }
    
}