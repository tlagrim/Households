//
//  GroceryTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import UIKit

class GroceryTableViewController: PFQueryTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("class: GroceryTVC")
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

        let grocery = PFQuery(className: Grocery.parseClassName())
        grocery.includeKey("creator")
        grocery.orderByAscending("updatedAt")
        
        if let user = PFUser.currentUser() {
            print("query!.whereKey(\"houshold_creator\", equalTo: user)")
            grocery.whereKey("creator", equalTo: user)
            print("showing households where user is an occupant somewhere")
        }
        print("about to return the query in\nqueryForTable()")
        return grocery        
    }
    
    
    /*
    This method replaces the UITableView data source method tableView(_:cellForRowAtIndexPath:) with a more suitable form. You get the returned PFObject as a parameter, without the need search it in a results array using and index path.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell", forIndexPath: indexPath) as! GroceryTableViewCell
        let grocery = object as! Grocery
        print("cell....")
        cell.groceryImage.file = grocery.image
        cell.groceryImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.groceryImage.loadInBackground(nil)
        cell.groceryTitle.text = grocery.name
        return cell
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
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
