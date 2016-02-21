//
//  HouseholdTableViewCell.swift
//  Households
//
//  Created by TJ Lagrimas on 1/30/16.
//
//

import Foundation
import UIKit

class HouseholdTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var householdImage: PFImageView!
    @IBOutlet weak var householdName: UILabel!
    @IBOutlet weak var householdKey: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
}