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
    var billToSend: Bill?
    // Occupy Object
    var currentOccupancyForNewBill: PFObject?
    
    override func viewDidLoad() {
        // print("Ajfkdl;")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // print(currentOccupancyForNewBill)
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.whereKey("occupant", equalTo: PFUser.currentUser()!)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancyForNewBill = objects![0]
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("inside createBillTVC")
    }
    
    func isEmptyField() -> Bool {
        // print(self.billDescription.text)
        
        if self.billDescription.text == "" || self.billDescription.text == nil {
            print("Bill Des name field is empty")
            
            let alert = UIAlertController(title: "Empty field!", message:"You must fill in the description field. Try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
            return true
        } else if self.billAmount.text == "" || self.billAmount.text == nil {
            let alert2 = UIAlertController(title: "Empty field!", message:"Must fill in the amount field. Try again.", preferredStyle: .Alert)
            alert2.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert2, animated: true){}
            return true
        } else {
            if let tempAmount = Double(self.billAmount.text!) {
                print("Temp: \(tempAmount) is a number")
                print("")
                return false
            }
            let alert3 = UIAlertController(title: "Invalid entry!", message:"The amount must be a number value. Try again.", preferredStyle: .Alert)
            alert3.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert3, animated: true){}
            return true
        }
    }
    
    @IBAction func createBillPressed(sender: AnyObject) {
        if isEmptyField() == false {
            
            let theDesc = self.billDescription.text
            let currentHousehold = currentOccupancyForNewBill?.objectForKey("household") as! PFObject
            let billCreator = PFUser.currentUser()
            let theAmount = self.billAmount.text
            let finalRemainingAmount: Double = Double(theAmount!)!
            
            let bill = Bill(creator: billCreator!, household: currentHousehold, is_complete: false, desc: theDesc!, total_amount: finalRemainingAmount, date_due: billDueDate.date, remaining_amount: finalRemainingAmount)
            do {
                try bill.save()
                self.billToSend = bill
                
            } catch {
                print(error)
            }
            
            /*
            { succeeded, error in
            if succeeded {
            self.billToSend = bill
            print("Created new bill successfully")
            //print("Bill created: ", bill)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BillsOverview")
            //self.presentViewController(viewController, animated: true, completion: nil)
            // self.navigationController?.popViewControllerAnimated(true)
            })
            } else {
            if let errorMessage = error?.userInfo["error"] as? String {
            print("Error!",errorMessage)
            }
            }
            } */
            
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(isEmptyField() == false && segue.identifier == "BillToPaymentsSegue"){
            let obj = self.billToSend
            print(obj)
            
            let VC = segue.destinationViewController as! CreatePaymentViewController
            // let createPaymentVC = navVC. as! CreatePaymentViewController
            VC.theIncomingBill = obj
            //   householdAssignmentsVC.currentOccupancy2 = obj
            //print("CreateBillViewContoller\nPrepare for segue\nObj to be sent:")
            //print(obj)
        }
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupancyDetail")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        //print("Cancel Pressed")
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}