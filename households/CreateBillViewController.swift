//
//  CreateBillViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/20/16.
//
//

import Foundation
import UIKit

class CreateBillViewController: UIViewController {
    
    @IBOutlet weak var billDescription: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var billDueDate: UIDatePicker!
    
    // Occupy Object
    var currentOccupancyForNewBill: PFObject?
    
    override func viewDidLoad() {
        print("Ajfkdsl;")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // print(currentOccupancyForNewBill)
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("inside createBillTVC")
    }
    
    @IBAction func createBillPressed(sender: AnyObject) {
        let theDesc = self.billDescription.text
        let currentHousehold = currentOccupancyForNewBill?.objectForKey("household") as! PFObject
        let billCreator = PFUser.currentUser()
        let theAmount = self.billAmount.text
        let finalRemainingAmount: Int = Int(theAmount!)!
        
        
        let bill = Bill(creator: billCreator!, household: currentHousehold, is_complete: false, desc: theDesc!, total_amount: finalRemainingAmount, date_due: billDueDate.date, remaining_amount: finalRemainingAmount)
        bill.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                print("Created new bill successfully")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BillsOverview")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            } else {
                if let errorMessage = error?.userInfo["error"] as? String {
                    print("Error!",errorMessage)
                }
            }
        }
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewBillToBillsOverview"){
            let obj = currentOccupancyForNewBill
            let navVC = segue.destinationViewController as! UINavigationController
            let householdAssignmentsVC = navVC.topViewController as! BillTableViewController
            householdAssignmentsVC.currentOccupancy2 = obj
            //print("CreateBillViewContoller\nPrepare for segue\nObj to be sent:")
            //print(obj)
        }
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        //print("Cancel Pressed")
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}