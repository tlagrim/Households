//
//  showHousematesTVC.swift
//  Households
//
//  Created by TJ Lagrimas on 4/12/16.
//
//


import Foundation

class showHousematesTVC: UITableViewController {
    
    var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberOptionsCell1", forIndexPath: indexPath) as! showHousematesTVCell
        cell.memberName.text = existingUsersInActiveOccupancy[indexPath.row].username
        
        if let theFile = existingUsersInActiveOccupancy[indexPath.row].valueForKey("image") as? PFFile {
            cell.memberImage.file = theFile
            cell.memberImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.memberImage.loadInBackground(nil)
        } else {
            print("No memberImage on file")
        }
        if existingUsersInActiveOccupancy[indexPath.row].valueForKey("phone_number")?.description.characters.count <= 0 ||  existingUsersInActiveOccupancy[indexPath.row].valueForKey("phone_number")?.description == nil {
            cell.memberPhone.text = "No number"
        } else {
            cell.memberPhone.text = existingUsersInActiveOccupancy[indexPath.row].valueForKey("phone_number")!.description
        }
        
        
        print("returning \(cell)||\n")
        return cell
    }
    
    
    
    
    // Edit the cell and delete by swiping left
    func tableVew(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    @IBOutlet var memberTableView: UITableView!
    @IBAction func cancelPressed(sender: AnyObject) {
        
         let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OccupanciesOverview")
         self.presentViewController(viewController, animated: true, completion: nil)

        
    }
    

    
    
}