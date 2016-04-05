//
//  PaymentTableViewController.swift
//  Households
//
//  Created by TJ Lagrimas on 3/1/16.
//
//

import Foundation

class PaymentTableViewController: PFQueryTableViewController {
    
    // must initialize this so that the parent controller has access
    weak var theParentVC: BillViewController?
    
    // 0 means just me
    // 1 means household
    var theSwitch: Int?
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    // both objects are Occupy objects
    var currentOccupancy: PFObject?
    // var currentOccupancy2: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if theSwitch == nil {
            // print("theSwitch is nil")
            theSwitch = 0 // default to showing just me payments
        }
        
        // print("The switch: ",theSwitch!)
        
        self.tableView.rowHeight = 30
        if self.revealViewController() != nil {
            openMenu.target = self.revealViewController()
            openMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let occupancyQuery = PFQuery(className: Occupy.parseClassName())
        occupancyQuery.whereKey("is_active_occupancy", equalTo: true)
        occupancyQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.currentOccupancy = objects![0]
                print(self.currentOccupancy!)
            } else {
                print("Sorry, couldn't get the Occupancy")
            }
        }
        
        //print(currentOccupancy)
        
        
        self.title = "Bills"
        //yourWeightTextField.addTarget(self, action:"yourWeightValueChanged:", forControlEvents:.ValueChanged);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
        
    }
    
    override func queryForTable() -> PFQuery {
        // print("\nPaymentTVC\nfunc queryForTable() PFQ")
        let paymentQuery = PFQuery(className: "Payment")
        paymentQuery.includeKey("bill")
        paymentQuery.includeKey("household")
        paymentQuery.includeKey("contributor")
        paymentQuery.whereKey("contributor", equalTo: PFUser.currentUser()!)
        paymentQuery.orderByAscending("createdAt")
        return paymentQuery
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        print("\nClass: PaymentTVC\nfunc tableView\n...\nret cell")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PaymentCell", forIndexPath: indexPath) as! PaymentTableViewCell
        
        let payment = object as! Payment
        
        cell.desc.text = payment.objectForKey("bill")!.valueForKey("desc")!.description
        
        let thePaymentAmount = payment.amount.description
        
        cell.totalAmount.text = "$\(thePaymentAmount)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "MMMM dd"
        
        cell.dateDue.text = dateFormatter.stringFromDate((payment.objectForKey("bill")?.valueForKey("date_due"))! as! NSDate)
        
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
        let thePaymentObj = self.objects![indexPath.row]
        let thePaymentAmount = thePaymentObj.valueForKey("amount")
        //let theBillName = thePaymentObj.valueForKey("desc")
        theParentVC!.amtBillPressedLabel.text = thePaymentAmount?.description
        //theParentVC!.nameBillPressedLabel.text = theBillName?.description
    }
    
}