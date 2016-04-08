//
//  AssignmentTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation

class AssignmentTableViewController: PFQueryTableViewController {
    

    // both objects are Occupy objects
    // var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    @IBOutlet var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        let assignmentQuery = PFQuery(className: Assignment.parseClassName())
        
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.whereKey("occupant", equalTo: PFUser.currentUser()!)
        assignmentQuery.includeKey("chore")
        assignmentQuery.includeKey("household")
        assignmentQuery.includeKey("assigned_to")
        assignmentQuery.includeKey("assignment_creator")
        // assignmentQuery.whereKey("household", matchesKey: "is_active_occupancy", inQuery: occupancyQuery)
        assignmentQuery.whereKey("household", matchesKey: "household", inQuery: occupancyQuery)
        
        return assignmentQuery
        */
        
        
        if self.revealViewController() != nil {
            openMenu.target = self.revealViewController()
            openMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = "Chores"
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
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            print("PFUser == nil")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        } // elseif there is no current occupancy, then go to main menu
        
        print("loadObjects")
        loadObjects()
        print("finished loading objects")
    }
    
    override func queryForTable() -> PFQuery {
        print("\n\nClass: AssignmentTVC\nfunc queryForTable() PFQ")
        print("let query = PFQuery(className: Assignment.parseClassName())")
        let query = Assignment.query()
        
        return query!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell", forIndexPath: indexPath) as! AssignmentTableViewCell
        
        let assignment = object as! Assignment
        let assignmentChore = assignment.chore
        let assignedTo = assignment.assigned_to
        
        if let theFile = assignmentChore.valueForKey("chore_image") as? PFFile {
            //if let theFile = occupancy.household.valueForKey("household_image")?.file {
            cell.assignmentImage.file = theFile
            cell.assignmentImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.assignmentImage.loadInBackground(nil)
        } else {
            print("No choreImage on file")
        }
        
        if let choreTitle = assignmentChore.valueForKey("chore_title") {
            if let assTo = assignedTo.valueForKey("first_name") {
                cell.assignmentDescription.text = ("\(choreTitle) for \(assTo)")
            } else {
                cell.assignmentDescription.text = ("\(choreTitle) for someone")
            }
        } else {
            print("No choreTitle")
        }
        
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
    let indexPath = self.tableView.indexPathForSelectedRow
    // object to be sent is an Occupy object
    let obj = self.objects![indexPath!.row]
    */
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == "NewAssignmentSegue"){
    let indexPath = self.tableView.indexPathForSelectedRow
    // object is a Occupy object
    let obj = currentOccupancy
    let navVC = segue.destinationViewController as! UINavigationController
    let householdAssignmentsVC = navVC.topViewController as! CreateAssignmentViewController
    householdAssignmentsVC.currentOccupancyForNewAssignment = obj
    }
    }*/
}