//
//  AssignmentOptionsTVC.swift
//  Households
//
//  Created by TJ Lagrimas on 4/11/16.
//
//

import Foundation

class AssignmentOptionsTVC: PFQueryTableViewController {
    
    weak var theParentVC: CreateAssignmentViewController?
    
    var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 30
        self.title = "Select Jobs"
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let choreQuery = PFQuery(className: Chore.parseClassName())
        /*
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("occupant", equalTo: PFUser.currentUser()!)
        occupancyQuery.includeKey("household")
        occupancyQuery.includeKey("occupant")
        
        choreQuery.whereKey(<#T##key: String##String#>, matchesQuery: <#T##PFQuery#>)
         */
        choreQuery.orderByAscending("chore_title")
        return choreQuery
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        print("\nAsgOptions")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AsgOptionsCell", forIndexPath: indexPath) as! AssignmentOptionsTVCell
        let aChore = object as! Chore
        
        if let theFile = aChore.valueForKey("chore_image") as? PFFile {
            //if let theFile = occupancy.household.valueForKey("household_image")?.file {
            cell.jobImage.file = theFile
            cell.jobImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.jobImage.loadInBackground(nil)
        } else {
            print("No jobImage on file")
        }
        
        
        cell.jobName.text = aChore.valueForKey("chore_title") as? String
        return cell
    }
    
    // Edit the cell and delete by swiping left
    func tableVew(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let obj = self.objects![indexPath.row]
            obj.deleteInBackground()
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.objects?.count > 0 && self.objects?.count > indexPath.row {
            let theChoreObj = self.objects![indexPath.row]
            let theChoreName = theChoreObj.valueForKey("chore_title")
            theParentVC!.choreTitle.text = theChoreName?.description
        } else {
            self.loadNextPage()
        }
        print("pressed!")
    }
}