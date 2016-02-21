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
    var currentOccupancy: PFObject?
    var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NOTE: when currentOccupancy comes in,
        // immediately query for the household and users
        /// maybe this way we'll get the info before I need it.
        
        if currentOccupancy == nil && currentOccupancy2 == nil {
            print("both are nil")
        } else if currentOccupancy == nil && currentOccupancy2 != nil{
            print ("1st is nil, 2nd is not nil")
            currentOccupancy = currentOccupancy2
        } else if currentOccupancy != nil && currentOccupancy2 == nil {
            print ("2nd is nil, 1st is not nil")
        } else {
            print("both are not nil")
            currentOccupancy = currentOccupancy2
        }
        
        let household = currentOccupancy?.objectForKey("household")
        let householdName = household?.valueForKey("household_name")
        
        //self.title = householdName?.description
        self.title = "Chores"
        print("self.title = currentOccupancy?.description")
        print(currentOccupancy?.description)
     
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("Class: AssignmentTBC\nviewwillappear()\nloadObjects()")
        //loadObjects()
        
        

    }
    
    override func queryForTable() -> PFQuery {
        print("\n\nClass: AssignmentTVC\nfunc queryForTable() PFQ")
        print("let query = PFQuery(className: Assignment.parseClassName())")
        // let query = Assignment.query()
        let query = PFQuery(className: Assignment.parseClassName())
        
        if currentOccupancy == nil && currentOccupancy2 == nil {
            print("both are nil")            
        } else if currentOccupancy == nil && currentOccupancy2 != nil{
            print ("1st is nil, 2nd is not nil")
            currentOccupancy = currentOccupancy2
        } else if currentOccupancy != nil && currentOccupancy2 == nil {
            print ("2nd is nil, 1st is not nil")
        } else {
            print("both are not nil")
            currentOccupancy = currentOccupancy2
        }
        
        if let household = currentOccupancy?.objectForKey("household"){
        print(currentOccupancy)
        print(household)
        
        query.whereKey("household", equalTo: (household))
        } else {
            print("Heyo")
        }
        
        query.includeKey("chore")
        query.includeKey("household")
        query.includeKey("assigned_to")
        query.includeKey("assignment_creator")

        print("return query")
            

        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        print("\nClass: AssignmentTVC\nfunc tableView\n...\nret cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell", forIndexPath: indexPath) as! AssignmentTableViewCell
        
        // 2
        let assignment = object as! Assignment
        let assignmentChore = assignment.chore 
        let assignmentHousehold = assignment.household 
        let assignedTo = assignment.assigned_to
        let assignmentCreator = assignment.assignment_creator
        
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewAssignmentSegue"){
            let indexPath = self.tableView.indexPathForSelectedRow
            // object is a Occupy object
            let obj = currentOccupancy
            let navVC = segue.destinationViewController as! UINavigationController
            let householdAssignmentsVC = navVC.topViewController as! CreateAssignmentViewController
            householdAssignmentsVC.currentOccupancyForNewAssignment = obj
        }
    }
}