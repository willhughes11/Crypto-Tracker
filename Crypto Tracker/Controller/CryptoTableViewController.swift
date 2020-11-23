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
    let searchController = UISearchController(searchResultsController: nil)
    
    var cellData = [TableCellData]()
    var loading = true
    var filteredCryptos: [TableCellData] = []
    var returnValue = true
    var indicator = UIActivityIndicatorView(style: .large)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        loadTableCell()
        searchBarParams()
    }
    
    func loadTableCell(){
        CryptoClient.getTableCellData(completionHandler: { data, error in
            self.cellData = data
            self.loading = false
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.tableView.reloadData()
            }
        })
    }
    
    func setColor(label: UILabel){
        if let text = label.text?.dropLast(), let value = Float(text) {
            if value < 0{
                label.textColor = UIColor(red: 217/255, green: 65/255, blue: 55/255, alpha: 1.0)
            } else if value > 0{
                label.textColor = UIColor(red: 109/255, green: 191/255, blue: 165/255, alpha: 1.0)
            }
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 50, width: 100, height: 100))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        if(self.loading == true){
            self.indicator.startAnimating()
            self.indicator.backgroundColor = .white
        }
    }
    
    func filterContentForSearchText(_ searchText: String){
        filteredCryptos = self.cellData.filter{ (cellData: TableCellData) -> Bool in
            return cellData.name.lowercased().contains(searchText.lowercased())
        }
        filteredCryptos += self.cellData.filter{(cellData: TableCellData) -> Bool in
            if(cellData.name.lowercased().contains(cellData.symbol.lowercased()) == false){
                self.returnValue = cellData.symbol.lowercased().contains(searchText.lowercased())
            } else{
                self.returnValue = false
            }
            return returnValue
        }
        self.tableView.reloadData()
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    
}

