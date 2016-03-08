//
//  CreateAssignmentViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/2/16.
//
//

import Foundation
import UIKit

class CreateAssignmentViewController: UIViewController {
    
    @IBOutlet weak var choreTitle: UITextField!
    @IBOutlet weak var assignTo: UITextField!
    
    
    // Occupy Object
    var currentOccupancyForNewAssignment: PFObject?
    // var username: String?
    
    override func viewDidLoad() {
        // let thecurrentOccupancyForNewAssignment = currentOccupancyForNewAssignment
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // this block of code grabs the current Occupancy
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancyForNewAssignment = objects![0]
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        print("inside createhouseholdVC")
    }
    
    func isEmptyField() -> Bool {
        print(self.choreTitle.text)
        if self.choreTitle.text == "" {
            print("Assignment field is empty")
            let alert = UIAlertController(title: "Empty field!", message:"You must pick a chore. Try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            return true
        } else  if self.assignTo.text == "" {
            //print("Assigned To field is empty")
            let alert2 = UIAlertController(title: "Empty field!", message:"You must assign this chore. Try again.", preferredStyle: .Alert)
            alert2.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
            self.presentViewController(alert2, animated: true){}
            return true
        } else {
            print("They are okay")
            return false
        }
    }
    
    @IBAction func newAssignmentPressed(sender: AnyObject) {
        // userAssignTo             YES
        // theChore                 YES
        // assignment creator       YES
        // theHousehold             YES
        
        if isEmptyField() == false {
            let currentOccupant = currentOccupancyForNewAssignment?.objectForKey("occupant") as! PFUser
            let currentHousehold = currentOccupancyForNewAssignment?.objectForKey("household") as! PFObject
            
            print("Current Occupant: ",currentOccupant)
            print("Current Household: ", currentHousehold)
            
            let choreAssignedTo = self.assignTo.text
            let choreTitleToAssign = self.choreTitle.text
            
            var theChore = PFObject(className: "Chore")
            var userAssignedTo = PFUser()
            
            // let assignmentQuery = PFQuery(className: Assignment.parseClassName())
            let choreQuery = PFQuery(className: Chore.parseClassName())
            let assignToQuery = PFUser.query()
            
            assignToQuery?.whereKey("username", equalTo: choreAssignedTo!)
            choreQuery.whereKey("chore_title", equalTo: choreTitleToAssign!)
            
            choreQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    theChore = objects![0]
                    print("Successfully got theChore: ", theChore)
                } else {
                    print("Sorry, couldn't get the theChore")
                }
            }
            
            
            assignToQuery!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    print("TJ, we successfully retrieved objects: \(objects)")
                    
                    userAssignedTo = objects![0] as! PFUser
                    userAssignedTo.signUpInBackgroundWithBlock { (success, error) -> Void in
                        print("Signed up user")
                        let assignment = Assignment(chore: theChore, household: currentHousehold, assigned_to: userAssignedTo, assignment_creator: currentOccupant, message: "Automated", is_complete: false)
                        
                        assignment.saveInBackgroundWithBlock{ succeeded, error in
                            
                            if succeeded {
                                print("Assignment to be saved\n: \(assignment)")
                                print("Created new assignment successfully")
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBar")
                                    self.presentViewController(viewController, animated: true, completion: nil)
                                    //self.navigationController?.popViewControllerAnimated(true)
                                    
                                })
                            } else {
                                if let errorMessage = error?.userInfo["error"] as? String {
                                    print("Error!",errorMessage)
                                }
                            }
                        }
                        
                    }
                } else {
                    print("Sorry TJ\nNot able to get the chore...")
                }
            }
        } else {
            
            print("asdf")
            
            
            
        }
    }
    /*
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == "NewAssToAssignmentsOverview"){
    let obj = currentOccupancyForNewAssignment
    let navVC = segue.destinationViewController as! UINavigationController
    let householdAssignmentsVC = navVC.topViewController as! AssignmentTableViewController
    householdAssignmentsVC.currentOccupancy2 = obj
    print("CreateAssignmentViewContoller\nPrepare for segue\nObj to be sent:")
    print(obj)
    }
    }*/
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBar")
        self.presentViewController(viewController, animated: true, completion: nil)
        print("Cancel Pressed")
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}