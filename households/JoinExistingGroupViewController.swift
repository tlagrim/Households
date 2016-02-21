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
    }
    
    @IBAction func joinPressed(sender: AnyObject) {
        let keyString = self.keyInput.text
        var theHousehold = Household() as! PFObject
        let hquery = PFQuery(className: Household.parseClassName())
        hquery.whereKey("key", equalTo: keyString!)
        
        hquery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                theHousehold = objects![0]
                let occupy = PFObject(className: Occupy.parseClassName())
                occupy["occupant"] = PFUser.currentUser()
                occupy["household"] = theHousehold
                occupy.saveInBackgroundWithBlock{ succeeded, error in
                    if succeeded {
                        print("Created new Occupancy successfully")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyOccupancies")
                            self.presentViewController(viewController, animated: true, completion: nil)
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
    }
    
}