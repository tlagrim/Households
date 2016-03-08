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
    // var currentOccupancy2: PFObject?
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            openMenu.target = self.revealViewController()
            openMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // NOTE: when currentOccupancy comes in,
        // immediately query for the household and users
        /// maybe this way we'll get the info before I need it.
        /*
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
        }*/
        
        // this block of code grabs the current Occupancy
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancy = objects![0]
                for obj in objects!{
                    print("Got obj: ",obj)
                }
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        //let household = currentOccupancy?.objectForKey("household")
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
        //print("\n\nTJClass: ListingTVC\nfunc queryForTable() PFQ")
        let query = Listing.query()
        return query!
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
            cell.listingName.text = (groceryTitle as! String)
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
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "WishlistToGrocerySegue"){
            let obj = currentOccupancy
            let navVC = segue.destinationViewController as! CreateListingViewController
            //let householdAssignmentsVC = navVC.topViewController as! CreateListingViewController
            navVC.currentOccupancyForNewListing = obj
        }
    }*/
}