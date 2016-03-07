//
//  JustMeBillTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 3/5/16.
//
//

import Foundation

class JustMeBillTableViewController: PFQueryTableViewController {
    
    weak var theParentVC: BillViewController?
    
    // 0 means just me
    // 1 means household
    var theSwitch: Int?
    
    // both objects are Occupy objects
    var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if theSwitch == nil {
            print("theSwitch is nil")
            theSwitch = 1 // default to showing household bills
        }
        
        self.tableView.rowHeight = 30
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancy = objects![0]
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        self.title = "Bills"
    }
    
    override func viewWillAppear(animated: Bool) {
        //loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        print("\n\nTJbilszClass: BillTVC\nfunc queryForTable() PFQ")
        let billQuery = Bill.query()
        billQuery?.includeKey("household")
        billQuery?.includeKey("creator")
        billQuery?.whereKey("creator", equalTo: PFUser.currentUser()!)
        
        return billQuery!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        print("\nClass: HouseholdBillTVC\nfunc tableView\n...\nret cell")
        print("The ob: ",object)
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("JustMeBillCell", forIndexPath: indexPath) as! JustMeBillTableViewCell
        
        let bill = object as! Bill
        
        cell.desc.text = bill.desc
        let theBillTotalAmount = bill.total_amount.description
        cell.totalAmount.text = "$\(theBillTotalAmount)"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "MMMM dd"
        
        cell.dateDue.text = dateFormatter.stringFromDate(bill.date_due)
        
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
        let theBillObj = self.objects![indexPath.row]
        let theBillAmount = theBillObj.valueForKey("total_amount")
        let theBillName = theBillObj.valueForKey("desc")
        theParentVC!.amtBillPressedLabel.text = theBillAmount?.description
        theParentVC!.nameBillPressedLabel.text = theBillName?.description
        // print("Household Name: ", theBillObj.objectForKey("household")!.valueForKey("household_name")!)
    }
}