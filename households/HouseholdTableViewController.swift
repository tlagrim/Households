//
//  GroupsTableViewController.swift
//  JobManagerTools
//
//  Created by TJ Lagrimas on 12/3/15.
//  Copyright © 2015 Timothy Lagrimas. All rights reserved.
//

import UIKit

class HouseholdTableViewController: PFQueryTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("class: theHouseholdTVC")
    }
    override func viewDidAppear(animated: Bool) {
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        // 4
        let image = UIImage(named: "householdsmainlogo")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
    }
    
    @IBAction func logOutPressed(sender: AnyObject) {
        print("Pressed logout")
        PFUser.logOut()
        print("Logout successful")
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Every time the view appears, you want to reload the query and the table view.
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear()")
        if (PFUser.currentUser() == nil) {
            print("PFUser == nil")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
        print("loadObjects")
        loadObjects()
        print("finished loading objects")
    }
    
    //Every time the view appears, you want to reload the query and the table view. To specify which query to run, you override queryForTable() to return a query for a Household.
    override func queryForTable() -> PFQuery {
        print("override func queryForTable() -> PFQuery")
        // checking for groups associated with users
        // but are not necessarily creators
        // query from user to associated persons
        // 1. get persons created by current user
        // query from persons to immediate groups
        print("let query = Household.query()")
        let query = Household.query()
        //let query = PFQuery(className: "Occupy")
        //let innerQuery = Person.query()
        print("if let user = PFUser.currentUser()")
        if let user = PFUser.currentUser() {
            print("query!.whereKey(\"houshold_creator\", equalTo: user)")
            query?.whereKey("household_creator", equalTo: user)
            print("showing households where user is an occupant somewhere")
        }
        print("about to return the query in\nqueryForTable()")
        return query!
        
    }
    
    
    /*
    This method replaces the UITableView data source method tableView(_:cellForRowAtIndexPath:) with a more suitable form. You get the returned PFObject as a parameter, without the need search it in a results array using and index path.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        print("override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell?")
        // 1
        // Dequeue a cell from the table view, and cast it to a GroupsTableViewCell.
        print("let cell = tableView.dequeueReusableCellWithIdentifier(\"HouseholdCell\", forIndexPath: indexPath) as! HouseholdTableViewCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseholdCell", forIndexPath: indexPath) as! HouseholdTableViewCell
        
        // 2
        // Cast the given PFObject to a Group object
        print("let house = object as! Household")
        let house = object as! Household
        //let person = PFObject as! Person
        
        // 3
        // Download the post image using PFImageView‘s loadInBackground method.
        // In the completion closure you track the download’s progress.
        // Here you fill a UIProgressBar as the image downloads.
        print("cell....")
        cell.householdImage.file = house.household_image
        cell.householdImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.householdImage.loadInBackground(nil) { percent in
            cell.progressView.progress = Float(percent)*0.01
            print("\(percent)%")
        }
        
        cell.householdName.text = house.household_name
        cell.householdKey.text = house.key
        print("return cell")
        return cell
    }
    
    
    // Edit the cell and delete by swiping left
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
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "editStore"
    {
    let toJobs = segue.destinationViewController as! JobsTableViewController
    let group = PFObject.self as! Group
    let groupId = group.key
    toJobs.gId = groupId
    
    }
    
    }
    */
    
}

