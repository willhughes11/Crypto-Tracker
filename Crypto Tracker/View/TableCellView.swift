//
//  TableCellView.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import Foundation
import UIKit

class TableCellView: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hourChange: UILabel!
    @IBOutlet weak var dayChange: UILabel!
    @IBOutlet weak var weekChange: UILabel!
}
