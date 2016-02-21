//
//  Lagriams.swift
//  Households
//
//  Created by TJ Lagrimas on 2/21/16.
//
//

import Foundation
class ViewController: UIViewController {
    @IBOutlet var Open: UIBarButtonItem!
    override func viewDidLoad() {
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
    }
}