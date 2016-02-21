//
//  CreateListingTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import Foundation
import UIKit

class CreateListingViewController: UIViewController {
    
    @IBOutlet weak var groceryTitle: UITextField!
    
    // Occupy Object
    var currentOccupancyForNewListing: PFObject?
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    override func viewWillAppear(animated: Bool) {
        print("inside createListingVC")
    }
    
    @IBAction func newWishlistPressed(sender: AnyObject) {
        // theGrocery               NO
        // grocery creator          NO
        // theHousehold             NO
        
        // Occupy (occupant, household)
        let currentHousehold = currentOccupancyForNewListing?.objectForKey("household") as! PFObject
        // print("Current Household: ", currentHousehold)
        
        let groceryNameToAssign = self.groceryTitle.text
        
        var theGrocery = PFObject(className: "Grocery")
        let userListedTo = PFUser.currentUser()
        
        // let assignmentQuery = PFQuery(className: Assignment.parseClassName())
        let groceryQuery = PFQuery(className: Grocery.parseClassName())
        
        groceryQuery.whereKey("name", equalTo: groceryNameToAssign!)
        groceryQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                theGrocery = objects![0]
                print("Successfully got theGrocery: ", theGrocery)
                let listing = Listing(grocery_item: theGrocery, household: currentHousehold, creator: userListedTo!, quantity: 1, priority: 1, detail: "None", is_private: false)
                listing.saveInBackgroundWithBlock{ succeeded, error in
                    
                    if succeeded {
                        print("Listing to be saved\n: \(listing)")
                        print("Created new listing successfully")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupanciesOverview")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    } else {
                        if let errorMessage = error?.userInfo["error"] as? String {
                            print("Error!",errorMessage)
                        }
                    }
                }
            } else {
                print("Sorry, couldn't get the theGrocery")
            }
        }
        
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewListingToListingsOverview"){
            let obj = currentOccupancyForNewListing
            let navVC = segue.destinationViewController as! UINavigationController
            let householdAssignmentsVC = navVC.topViewController as! ListingTableViewController
            householdAssignmentsVC.currentOccupancy2 = obj
            print("CreateAssignmentViewContoller\nPrepare for segue\nObj to be sent:")
            print(obj)
        }
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupanciesOverview")
        self.presentViewController(viewController, animated: true, completion: nil)
        print("Cancel Pressed")
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}