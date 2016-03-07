//
//  CreatePaymentViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 3/1/16.
//
//


import Foundation
import UIKit

class CreatePaymentViewController: UIViewController {
    
    @IBOutlet weak var contrTxtField: UITextField!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var addContributorBtn: UIButton!
    @IBOutlet weak var segCtrlPrivacy: UISegmentedControl!
    @IBOutlet weak var incomingBillLabel: UILabel!
    
    var theIncomingBill: Bill! // the associated bill for the following payments
    var currentOccupancyForNewPayment: PFObject?
    var segCtrlPrivacyVal = true // defaults to just me (true)
    var txtContrFieldY = 0
    var numContributorsAdded = 0
    var txtContrField: UITextField = UITextField(frame: CGRect(x: 27, y: 285, width: 170.00, height: 30.00));
    var txtContrFields: [UITextField] = []
    var txtPercentageField: UITextField = UITextField(frame: CGRect(x: 205, y: 285, width: 40.00, height: 30.00));
    var txtPercentageFields: [UITextField] = []
    var subtotalLabel: UILabel = UILabel(frame: CGRect(x: 250, y: 285, width: 50, height: 30))
    var subtotalLabels: [UILabel] = []
    var pInVals: [Double] = []
    var tempPVal: Double = 1
    var tempSubTotal: Double = 1
    
    override func viewDidLoad() {
        addContributorBtn.hidden = true
        contrTxtField.hidden = true
        
        self.incomingBillLabel.text = theIncomingBill.desc
        self.totalAmtLbl.text = theIncomingBill!.valueForKey("total_amount")!.description
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancyForNewPayment = objects![0]
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("")
    }
    
    
    @IBAction func calcSubPressed(sender: AnyObject) {
        for label in subtotalLabels { label.hidden = false }
        
        for var index=0; index<numContributorsAdded; index++ {
            
            pInVals.append(Double(self.txtPercentageFields[index].text!)!)
            tempPVal = Double(txtPercentageFields[index].text!)!
            tempPVal = tempPVal * 0.01 // gives percentage
            tempSubTotal = tempPVal * Double(theIncomingBill!.valueForKey("total_amount")!.description)!
            subtotalLabels[index].text = tempSubTotal.description
        }
    }
    
    
    
    
    @IBAction func createPaymentPressed(sender: AnyObject) {
        print("Numcontributorsadded: ",numContributorsAdded)
        if numContributorsAdded == 0 {
            let payment = Payment(bill: self.theIncomingBill, contributor: PFUser.currentUser()!, household: self.theIncomingBill.household, is_complete: false, is_repeat: false, is_private: self.segCtrlPrivacyVal, amount: self.theIncomingBill.total_amount, percentage: 100)
            payment.saveInBackgroundWithBlock{ succeeded, error in
                if succeeded {
                    print("Payment to be saved\n: \(payment)")
                    print("Created new assignment successfully")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssignmentsOverview")
                        //self.presentViewController(viewController, animated: true, completion: nil)
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                } else {
                    if let errorMessage = error?.userInfo["error"] as? String {
                        print("Error!",errorMessage)
                    }
                }
            }
        } else {
            for var index=0; index < numContributorsAdded; ++index {
                print("Index: ", index)
                
                // bill                     YES
                // CONTRIBUTOR              YES
                // theHousehold             YES
                
                createAndSavePayment(txtContrFields[index].text!, theIndex: index)
            }
        }
    }
    
    
    @IBAction func segCtrlPressed(sender: AnyObject) {
        if segCtrlPrivacy.selectedSegmentIndex == 0 {
            segCtrlPrivacyVal = true
            print("Just Me")
            contrTxtField.hidden = true
            addContributorBtn.hidden = true
            for field in txtPercentageFields { field.hidden = true }
            for pfield in txtContrFields { pfield.hidden = true }
            for label in subtotalLabels { label.hidden = true }
            txtContrFields = []
            txtPercentageFields = []
            subtotalLabels = []
            numContributorsAdded = 0
            txtContrFieldY = 0
        }
        if segCtrlPrivacy.selectedSegmentIndex == 1 {
            segCtrlPrivacyVal = false
            print("Household")
            contrTxtField.hidden = false
            addContributorBtn.hidden = false
            for field in txtPercentageFields { field.hidden = false }
            for pfield in txtContrFields { pfield.hidden = false }
            
        }
    }
    
    @IBAction func addContributorPressed(sender: AnyObject) {
        numContributorsAdded += 1
        txtContrFieldY = (numContributorsAdded - 1) * 40 + 285
        txtPercentageField = UITextField(frame: CGRect(x: 205, y: Double(txtContrFieldY), width: 40.00, height: 30.00));
        txtContrField = UITextField(frame: CGRect(x: 27, y: Double(txtContrFieldY), width: 170.00, height: 30.00));
        subtotalLabel = UILabel(frame: CGRect(x: 250, y: Double(txtContrFieldY), width: 50, height: 30));
        
        self.view.addSubview(txtContrField)
        self.view.addSubview(txtPercentageField)
        self.view.addSubview(subtotalLabel)
        
        //txtContrField.borderStyle = UITextBorderStyle.Line
        txtContrField.placeholder = "Contributor Username"
        txtContrField.backgroundColor = UIColor.cyanColor()
        txtContrField.font = UIFont.systemFontOfSize(15)
        txtContrField.borderStyle = UITextBorderStyle.RoundedRect
        
        txtPercentageField.borderStyle = UITextBorderStyle.RoundedRect
        txtPercentageField.font = UIFont.systemFontOfSize(15)
        txtPercentageField.keyboardType = UIKeyboardType.NumberPad
        //txtPercentageField.borderStyle = UITextBorderStyle.Line
        txtPercentageField.placeholder = "%"
        txtPercentageField.backgroundColor = UIColor.cyanColor()
        
        subtotalLabel.backgroundColor = UIColor.cyanColor()
        //subtotalLabel.text = "subt"
        subtotalLabel.font = UIFont.systemFontOfSize(13)
        
        
        txtContrFields.append(txtContrField)
        txtPercentageFields.append(txtPercentageField)
        subtotalLabels.append(subtotalLabel)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func createAndSavePayment(theContributor: String, theIndex: Int) {
        print("CreateAndSave Index: ", theIndex)
        
        var contributorAssignedTo = PFUser()
        let contributorQuery = PFUser.query()
        
        if theIndex < numContributorsAdded {
            
            
            if txtContrFields[theIndex].text != PFUser.currentUser()?.username {
                contributorQuery?.whereKey("username", equalTo: txtContrFields[theIndex].text!)
                contributorQuery!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if error == nil {
                        print("TJ, we successfully retrieved objects: \(objects)")
                        
                        contributorAssignedTo = objects![0] as! PFUser
                        contributorAssignedTo.signUpInBackgroundWithBlock { (success, error) -> Void in
                            print("Signed up user")
                            // self.createAndSavePayment(contributorAssignedTo, theIndex: index)
                            let payment = Payment(bill: self.theIncomingBill, contributor: contributorAssignedTo, household: self.theIncomingBill.household, is_complete: false, is_repeat: false, is_private: self.segCtrlPrivacyVal, amount: Double(self.subtotalLabels[theIndex].text!)!, percentage: Double(self.txtPercentageFields[theIndex].text!)!)
                            
                            payment.saveInBackgroundWithBlock{ succeeded, error in
                                if succeeded {
                                    print("Payment to be saved\n: \(payment)")
                                    print("Created new assignment successfully")
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        //let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssignmentsOverview")
                                        //self.presentViewController(viewController, animated: true, completion: nil)
                                        self.navigationController?.popViewControllerAnimated(true)
                                    })
                                } else {
                                    if let errorMessage = error?.userInfo["error"] as? String {
                                        print("Error!",errorMessage)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        print("Sorry TJ\nNot able to sign up the user...")
                    }
                }
            } else {
                print("Assigned to Current User, not signing in.")
                contributorAssignedTo = PFUser.currentUser()!
                
                let payment = Payment(bill: self.theIncomingBill, contributor: contributorAssignedTo, household: self.theIncomingBill.household, is_complete: false, is_repeat: false, is_private: self.segCtrlPrivacyVal, amount: Double(self.subtotalLabels[theIndex].text!)!, percentage: Double(self.txtPercentageFields[theIndex].text!)!)
                
                payment.saveInBackgroundWithBlock{ succeeded, error in
                    if succeeded {
                        print("Payment to be saved\n: \(payment)")
                        print("Created new assignment successfully")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AssignmentsOverview")
                            //self.presentViewController(viewController, animated: true, completion: nil)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    } else {
                        if let errorMessage = error?.userInfo["error"] as? String {
                            print("Error!",errorMessage)
                        }
                    }
                }
            }
        }
    }
}