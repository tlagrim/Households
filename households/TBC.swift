//
//  TBC.swift
//  Households
//
//  Created by TJ Lagrimas on 2/16/16.
//
//

import Foundation
import UIKit

class TBC: UITableViewController {
    var arrayOf = [String]()
    
    override func viewDidLoad() {
        arrayOf = ["TJ","Tppds", "fdsa"]
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOf.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = arrayOf[indexPath.row]
        return cell
    }
    
    
    
    
}