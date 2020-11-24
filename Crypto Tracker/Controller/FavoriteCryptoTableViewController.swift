//
//  FavoriteCryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import Foundation
import UIKit
import CoreData
import SDWebImage

class FavoriteCryptoTableView: UITableViewController {
    
    // MARK: - Properties: Variables and Constants
    
    let numberFormatter = NumberFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let searchController = UISearchController(searchResultsController: nil)
    
    var cellData = [TableCellData]()
    var loading = false
    var watchlistIds: [Int] = []
    var filteredCryptos: [Cryptocurrency] = []
    var returnValue = true
    var indicator = UIActivityIndicatorView(style: .large)
    
    lazy var fetchedResultsController: NSFetchedResultsController<Cryptocurrency> = {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "cmc_rank", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        searchBarParams()
        try? fetchedResultsController.performFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    //MARK: - Functions
    
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
        filteredCryptos = (self.fetchedResultsController.fetchedObjects?.filter{ (cellData: Cryptocurrency) -> Bool in
            return (cellData.name?.lowercased().contains(searchText.lowercased()))!
        })!
        filteredCryptos += (self.fetchedResultsController.fetchedObjects?.filter{(cellData: Cryptocurrency) -> Bool in
            if(cellData.name?.lowercased().contains(cellData.symbol?.lowercased() ?? searchText.lowercased()) == false){
                self.returnValue = ((cellData.symbol?.lowercased().contains(searchText.lowercased())) != nil)
            } else{
                self.returnValue = false
            }
            return returnValue
        })!
        self.tableView.reloadData()
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func showAlert(){
        let alert:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.title = "Network Failure"
        alert.message = "Can't connect to API"
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
