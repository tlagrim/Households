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
        TableArray = ["ToOccupanciesCell","ToHousematesCell"]
        self.tableView.backgroundColor = UIColor.grayColor()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        // cell.textLabel?.text = TableArray[indexPath.row]
        if indexPath.row == 0 {
            self.tableView.rowHeight = 200
        } else {
            self.tableView.rowHeight = 40
        }

        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        //cell.contentView.alpha = 0.9
        return cell
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var DestVC = segue.destinationViewController as! ViewController
    var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
    DestVC.varView = indexPath.row
    }*/
    
}