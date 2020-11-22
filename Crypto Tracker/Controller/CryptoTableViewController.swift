//
//  ViewController.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import UIKit

class CryptoTableViewController: UITableViewController {
    
    let CryptoClient = CMCClient()
    let numberFormatter = NumberFormatter()
    
    var cellData = [TableCellData]()
    var loading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableCell()
    }
}

