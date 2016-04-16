//
//  MemberOptionsTVC.swift
//  Households
//
//  Created by TJ Lagrimas on 4/11/16.
//
//

import Foundation

class MemberOptionsTVC: UITableViewController {
    weak var theParentVC: CreateAssignmentViewController?
    
    var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 30
        self.title = "Select Members"
    }
    
    override func viewWillAppear(animated: Bool) {
        // loadObjects()
        memberTableView.reloadData()

    }
    /*
     
     override func queryForTable() -> PFQuery {
     let occupancyQuery = PFQuery(className: Occupy.parseClassName())
     occupancyQuery.includeKey("occupant")
     occupancyQuery.includeKey("household")
     occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
     occupancyQuery.whereKey("occupant", equalTo: PFUser.currentUser()!)
     let userQuery = PFUser.query()
     
     
     
     return occupancyQuery
     }
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
     print("\nAsgOptions")
     
     let cell = tableView.dequeueReusableCellWithIdentifier("MemberOptionsCell", forIndexPath: indexPath) as! MemberOptionsTVCell
     let aGroup = object as! Occupy
     if let theFile = aGroup.objectForKey("occupant")?.valueForKey("image") as? PFFile {
     //if let theFile = occupancy.household.valueForKey("household_image")?.file {
     cell.memberImage.file = theFile
     cell.memberImage.contentMode = UIViewContentMode.ScaleAspectFit
     cell.memberImage.loadInBackground(nil)
     } else {
     print("No memberImage on file")
     }
     let name1 = aGroup.objectForKey("occupant")?.valueForKey("first_name") as? String
     if name1?.characters.count <= 0 {
     cell.memberName.text = aGroup.objectForKey("occupant")?.valueForKey("username") as? String
     } else {
     cell.memberName.text = name1
     }
     
     
     
     return cell
     }
     */
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingUsersInActiveOccupancy.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberOptionsCell", forIndexPath: indexPath) as! MemberOptionsTVCell
        cell.memberName.text = existingUsersInActiveOccupancy[indexPath.row].username

        if let theFile = existingUsersInActiveOccupancy[indexPath.row].valueForKey("image") as? PFFile {
            cell.memberImage.file = theFile
            cell.memberImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.memberImage.loadInBackground(nil)
        } else {
            print("No memberImage on file")
        }
        
        
        print("returning \(cell)||\n")
        return cell
    }
    

    

    // Edit the cell and delete by swiping left
    func tableVew(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    @IBOutlet var memberTableView: UITableView!

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theMemObj = existingUsersInActiveOccupancy[indexPath.row]
        let theMemName = theMemObj.valueForKey("username")
        theParentVC!.assignTo.text = theMemName?.description
    }
}