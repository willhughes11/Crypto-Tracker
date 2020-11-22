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
    
    let CryptoClient = CMCClient()
    let numberFormatter = NumberFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let searchController = UISearchController(searchResultsController: nil)
    
    var cellData = [TableCellData]()
    var loading = true
    var watchlistIds: [Int] = []
    var filteredCryptos: [TableCellData] = []
    var returnValue = true
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarParams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getWatchlistCryptos()
        loadTableCell()
    }

    func getWatchlistCryptos(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cryptocurrency")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    var coreDataArray:[Int] = []
                    for data in result as! [NSManagedObject] {
                        coreDataArray.append(data.value(forKey: "id") as! Int)
                        if(watchlistIds.contains(data.value(forKey: "id") as! Int) == false){
                            watchlistIds.append(data.value(forKey: "id") as! Int)
                        }
                    }
                    watchlistIds.sort()
                    coreDataArray.sort()
                    watchlistIds = watchlistIds.filter{ coreDataArray.contains($0)}
                } catch {
                    
                    print("Failed")
                }
        }
    
    func loadTableCell(){
        CryptoClient.getTableCellData(completionHandler: { data, error in
            for i in 0...data.count-1{
                if(self.watchlistIds.contains(data[i].id)){
                    if(self.cellData.contains(where: {$0.id == data[i].id}) == false){
                        self.cellData.append(data[i])
                    }
                }
            }
            self.cellData = self.cellData.filter{ self.watchlistIds.contains($0.id)}

            self.loading = false
            DispatchQueue.main.async {
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
    
    func filterContentForSearchText(_ searchText: String){
        filteredCryptos = self.cellData.filter{ (cellData: TableCellData) -> Bool in
            return cellData.name.lowercased().contains(searchText.lowercased())
        }
        filteredCryptos += self.cellData.filter{(cellData: TableCellData) -> Bool in
            if(cellData.symbol != cellData.name.prefix(3).uppercased()){
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
