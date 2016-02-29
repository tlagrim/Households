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
        if self.revealViewController() != nil {
            Open.target = self.revealViewController()
            Open.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}