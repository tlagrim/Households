//
//  BackTVC.swift
//  Households
//
//  Created by TJ Lagrimas on 2/21/16.
//
//

import Foundation

class BackTVC: UITableViewController {
    var TableArray = [String]()
    override func viewDidLoad() {
        TableArray = ["TJ","Timothy","Lagrimas"]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var DestVC = segue.destinationViewController as! ViewController
    var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
    DestVC.varView = indexPath.row
    }*/
    
}