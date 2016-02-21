//
//  ListingTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/9/16.
//
//

import Foundation

class ListingTableViewController: PFQueryTableViewController {
    
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
        //let householdName = household?.valueForKey("household_name")
        
        //self.title = householdName?.description
        self.title = "Grocery List"
        //print("self.title = currentOccupancy?.description")
        //print(currentOccupancy?.description)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        print("\n\nTJClass: ListingTVC\nfunc queryForTable() PFQ")
        //print("let query = PFQuery(className: Assignment.parseClassName())")
        // let query = Assignment.query()
        let query = PFQuery(className: Listing.parseClassName())
        
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
            //print(currentOccupancy)
            //print(household)
            
            query.whereKey("household", equalTo: household)
            
        } else {
            print("Heyo")
        }
        
        query.includeKey("grocery_item")
        query.includeKey("household")
        query.includeKey("creator")
        if let user = PFUser.currentUser() {
            query.whereKey("creator", equalTo: user)
        }
        // QUERY FOR T / F ON IS_PRIVATE
        
        //print("return query")
        
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        print("\nClass: ListingTVC\nfunc tableView\n...\nret cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("ListingCell", forIndexPath: indexPath) as! ListingTableViewCell
        
        // print(currentOccupancy)
        // 2
        let listing = object as! Listing
        print("Listing: ",listing)
        let listingGrocery = listing.grocery_item
        
        if let theFile = listingGrocery.valueForKey("image") as? PFFile {
            //if let theFile = occupancy.household.valueForKey("household_image")?.file {
            cell.listingImage.file = theFile
            cell.listingImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.listingImage.loadInBackground(nil)
        } else {
            print("No listingImage on file")
        }
        
        if let groceryTitle = listingGrocery.valueForKey("name") {
            cell.listingName.text = groceryTitle as! String
        } else {
            print("No listing Title")
        }
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "WishlistToGrocerySegue"){
            let obj = currentOccupancy
            let navVC = segue.destinationViewController as! CreateListingViewController
            //let householdAssignmentsVC = navVC.topViewController as! CreateListingViewController
            navVC.currentOccupancyForNewListing = obj
        }
    }
}