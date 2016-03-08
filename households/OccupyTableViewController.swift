//
//  OccupyTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation
class OccupyTableViewController: PFQueryTableViewController {
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            //menuButton.target = self.revealViewController()
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            print("PFUser == nil")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
        print("Class: OccupyTVC\nviewwillappear()\nloadObjects()")
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        print("Class: OccupyTVC\nfunc queryForTable() PFQ")
        print("let query...\nwhere key occupant equal to user\nret query")
        //let query = Occupy.query()
        let user = PFUser.currentUser()
        
        // 1
        // Create a PFQuery object for the Occupy class.
        print("let query = PFQuery(className: Occupy())")
        let occupancy = PFQuery(className: Occupy.parseClassName())
        
        // 2
        // Request that this query will return the full occupant and household details.
        // Without this line of code, the query will just return the
        // object reference of the user without its details.
        print("query.includeKey(\"createdBy\")")
        occupancy.whereKey("occupant", equalTo: user!)
        
        occupancy.includeKey("occupant")
        occupancy.includeKey("household")
        
        
        // 3
        // Sort the results by their creation date.
        print("query.orderByDescending(\"updatedAt\")")
        occupancy.orderByDescending("updatedAt")
        print("return query")
        
        return occupancy
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        print("Class: OccupyTVC\nfunc tableView\n...\nret cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("OccupyCell", forIndexPath: indexPath) as! OccupyTableViewCell
        
        // 2
        let occupancy = object as! Occupy
        cell.householdLabel.text = occupancy.household.valueForKey("household_name")?.description
        cell.membersLabel.text = "Occupants: "
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        // find all occupancies where occupy.household == currenthousehold

        // occupancyQuery.whereKey("occupant", matchesQuery: userQuery!)
        occupancyQuery.whereKey("household", equalTo: occupancy.household)
        occupancyQuery.includeKey("household")
        occupancyQuery.includeKey("occupant")
        
        // occupancyQuery.whereKey(, equalTo: <#T##AnyObject#>)
        // userQuery?.whereKey("", matchesQuery: <#T##PFQuery#>)
        
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // print("Object: ",object)
                    cell.membersLabel.text? += " "
                    cell.membersLabel.text! += object.objectForKey("occupant")!.valueForKey("first_name")!.description
                    // print("To Append: ",object.objectForKey("occupant")!.valueForKey("first_name")!.description)
                }
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        // print("Names: ",names)
        
        //cell.membersLabel.text = occupancy.occupant.valueForKey("first_name")?.description

        
        let isIt = occupancy.valueForKey("is_active_occupancy")!
        
        if (isIt as! NSObject == 1) {
            cell.contentView.backgroundColor = UIColor.greenColor()
            cell.householdLabel.text! += " (active)"
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        if let theFile = occupancy.household.valueForKey("household_image") as? PFFile {
            //if let theFile = occupancy.household.valueForKey("household_image")?.file {
            cell.householdImage.file = theFile
            cell.householdImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.householdImage.loadInBackground(nil) { percent in
                cell.progressView.progress = Float(percent)*0.01
                print("\(percent)%")
            }
        } else {
            print("No householdImage on file")
        }
        
        return cell
    }
    
    // add functionality to be able to edit and delete (2 functions)
    func tableVew(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //var selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! AssignmentTableViewCell
            /*tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            loadObjects()*/
            let obj = self.objects![indexPath.row]
            obj.deleteInBackground()
            tableView.reloadData()
        }
    }
    
    // Once a cell is pressed, this function sets false to previous is_active_occupancy
    // and sets true to the new one.
    // Afterwards, go back to the tabview with corresponding data
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let obj = self.objects![indexPath.row]
        for object in objects! {
            if object.valueForKey("is_active_occupancy") as! NSObject == 1 {
                object.setValue(false, forKey: "is_active_occupancy")
                object.saveInBackground()
                obj.setValue(true, forKey: "is_active_occupancy")
                obj.saveInBackground()
            } else {
                obj.setValue(true, forKey: "is_active_occupancy")
                obj.saveInBackground()
            }
        }
        
        // go to tabview called OccupancyDetail
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupancyDetail")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    /*
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "HouseholdDetailsSegue"){
            let indexPath = self.tableView.indexPathForSelectedRow
            // object to be sent is an Occupy object
            let obj = self.objects![indexPath!.row]
            let tabBarVC = segue.destinationViewController as! UITabBarController
            
            let nav0 = tabBarVC.viewControllers![0] as! UINavigationController
            let destVC0 = nav0.topViewController as! AssignmentTableViewController
            destVC0.currentOccupancy = obj
            
            
            let nav1 = tabBarVC.viewControllers![1] as! UINavigationController
            let destVC1 = nav1.topViewController as! ListingTableViewController
            destVC1.currentOccupancy = obj
            
            let nav2 = tabBarVC.viewControllers![2] as! UINavigationController
            let destVC2 = nav2.topViewController as! BillTableViewController
            destVC2.currentOccupancy = obj
            
        }
    } */
}