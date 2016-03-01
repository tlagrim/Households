//
//  BillTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation

class BillTableViewController: PFQueryTableViewController {
    
    // must initialize this so that the parent controller has access
    weak var theParentVC: BillViewController?

    @IBOutlet weak var openMenu: UIBarButtonItem!
    // both objects are Occupy objects
    var currentOccupancy: PFObject?
   // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 30
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
        } */
        // this block of code grabs the current Occupancy
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancy = objects![0]
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        // let household = currentOccupancy?.objectForKey("household")
        // let householdName = household?.valueForKey("household_name")
        
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
        
        let query = Bill.query()
        
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
        /*
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

        */
        return query!
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theBillObj = self.objects![indexPath.row]
        let theBillAmount = theBillObj.valueForKey("total_amount")
        let theBillName = theBillObj.valueForKey("desc")
        theParentVC!.amtBillPressedLabel.text = theBillAmount?.description
        theParentVC!.nameBillPressedLabel.text = theBillName?.description
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ToCreateBillSegue"){
            let obj = currentOccupancy
            let navVC = segue.destinationViewController as! CreateBillViewController
            //let householdAssignmentsVC = navVC.topViewController as! CreateListingViewController
            navVC.currentOccupancyForNewBill = obj
        }
    }*/
}