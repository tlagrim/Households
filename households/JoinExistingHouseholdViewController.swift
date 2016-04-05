//
//  JoinExistingGroupViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation
import UIKit



class JoinExistingHouseholdViewController: UIViewController {
    
    
    @IBOutlet weak var keyInput: UITextField!
    
    
    override func viewDidLoad() {
        print("inside of JoinExistingHouseholdViewController")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func isExistingHousehold() -> Bool {
        var htem: Household?
        for i in existingHouseholds{ print("i:",i)
            htem = (i as! Household)
            print("key: ",htem!.key)
            
            
            if htem!.key == self.keyInput.text {
                return true
            }
            
            
            
        }
        return false
    }
    
    @IBAction func joinPressed(sender: AnyObject) {
        if self.keyInput.text != "" || self.keyInput.text == nil {
            if isExistingHousehold() {
                let keyString = self.keyInput.text
                var theHousehold = Household() as PFObject
                let hquery = PFQuery(className: Household.parseClassName())
                hquery.whereKey("key", equalTo: keyString!)
                
                hquery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if error == nil {
                        theHousehold = objects![0]
                        let occupy = PFObject(className: Occupy.parseClassName())
                        occupy["occupant"] = PFUser.currentUser()
                        occupy["household"] = theHousehold
                        occupy["is_active_occupancy"] = false
                        occupy.saveInBackgroundWithBlock{ succeeded, error in
                            if succeeded {
                                print("Created new Occupancy successfully")
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    //let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyOccupancies")
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
                        print("Sorry, couldn't get the household")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Household is nonexistent", message:"The household \'\(self.keyInput.text!)\' does not match and our records. Try again.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        } else {
            let alert2 = UIAlertController(title: "Empty field!", message:"You must fill in both fields. Try again.", preferredStyle: .Alert)
            alert2.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert2, animated: true){}
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}