//
//  ViewController.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import UIKit

class CryptoTableViewController: UITableViewController {
    
    // MARK: - Properties: Variables and Constants
    
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
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        searchBarParams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTableCell()
    }
    
    //MARK: - Data Loading Functions
    
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
    
    func handleResponse(response: TableCellData?, error: Error?){
        guard error == nil , response != nil else {
            showError(title: "Error1", message: error?.localizedDescription ?? "try again later")
            return
        }
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
    
    //MARK: - Searchbar Functions
    
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
    
    //MARK: - Alert Functions
    
    func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
