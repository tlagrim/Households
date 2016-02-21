//
//  OccupyTableViewCell.swift
//  Households
//
//  Created by TJ Lagrimas on 2/1/16.
//
//

import Foundation
import UIKit
import Parse

class OccupyTableViewCell: PFTableViewCell {
    @IBOutlet weak var householdLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var householdImage: PFImageView!
    @IBOutlet weak var progressView: UIProgressView!
}