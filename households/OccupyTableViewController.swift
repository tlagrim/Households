//
//  OccupyTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation
class OccupyTableViewController: PFQueryTableViewController {
    
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
        let query = Occupy.query()
        return query!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        print("Class: OccupyTVC\nfunc tableView\n...\nret cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("OccupyCell", forIndexPath: indexPath) as! OccupyTableViewCell
        
        // 2
        let occupancy = object as! Occupy
        cell.householdLabel.text = occupancy.household.valueForKey("household_name")?.description
        cell.membersLabel.text = occupancy.occupant.valueForKey("first_name")?.description

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
    }
}