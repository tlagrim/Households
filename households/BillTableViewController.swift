//
//  BillTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation

class BillTableViewController: PFQueryTableViewController {
    
    // both objects are Occupy objects
    var currentOccupancy: PFObject?
    var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 30
        
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
        self.title = "Bills"
        //print("self.title = currentOccupancy?.description")
        //print(currentOccupancy?.description)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        print("\n\nTJbilszClass: BillTVC\nfunc queryForTable() PFQ")
        
        let query = PFQuery(className: Bill.parseClassName())
        
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
            
            // this should cover all bills in the given household
            query.whereKey("household", equalTo: household)
            
        } else {
            print("Heyo")
        }
        
        query.includeKey("household")
        query.includeKey("creator")

        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        print("\nClass: BillTVC\nfunc tableView\n...\nret cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("BillCell", forIndexPath: indexPath) as! BillTableViewCell
        
        // print(currentOccupancy)
        // 2
        let bill = object as! Bill
        // print("Bill: ",bill)
    
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ToCreateBillSegue"){
            let obj = currentOccupancy
            let navVC = segue.destinationViewController as! CreateBillViewController
            //let householdAssignmentsVC = navVC.topViewController as! CreateListingViewController
            navVC.currentOccupancyForNewBill = obj
        }
    }
}