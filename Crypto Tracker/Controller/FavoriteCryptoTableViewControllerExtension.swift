//
//  FavoriteCryptoTableViewControllerExtension.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/22/20.
//

import Foundation
import UIKit
import CoreData

extension FavoriteCryptoTableView {
    
    //MARK: - Override Table View Functions
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            print(filteredCryptos.count)
            return filteredCryptos.count
        } else {
            return fetchedResultsController.fetchedObjects?.count ?? 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! TableCellView
        if loading {
            cell.selectionStyle = .none
        } else {
            if isFiltering{
                let crypto = filteredCryptos[indexPath.row]
                let imageUrl:URL? = URL(string: crypto.logo ?? "N/A")
                cell.logo.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "genericLogo.png"))
                cell.symbol.text = crypto.symbol
                cell.name.text = crypto.name
                numberFormatter.numberStyle = .currency
                cell.price.text = numberFormatter.string(from: NSNumber(value: crypto.price ))
                cell.hourChange.text = String(format:"%.2f%%",crypto.percent_change_1h)
                cell.dayChange.text = String(format:"%.2f%%",crypto.percent_change_24h)
                cell.weekChange.text = String(format:"%.2f%%",crypto.percent_change_7d)
                
                cell.symbol.font = UIFont(name:"HelveticaNeue-Bold",size: 20.0)
                cell.price.font = UIFont(name:"HelveticaNeue-Bold",size: 20.0)
                cell.hourChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                cell.dayChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                cell.weekChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                
                setColor(label: cell.hourChange)
                setColor(label: cell.dayChange)
                setColor(label: cell.weekChange)
            } else {
                let crypto = fetchedResultsController.fetchedObjects?[indexPath.row]
                let imageUrl:URL? = URL(string: crypto?.logo ?? "N/A")
                cell.logo.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "genericLogo.png"))
                cell.symbol.text = crypto?.symbol ?? "N/A"
                cell.name.text = crypto?.name
                numberFormatter.numberStyle = .currency
                cell.price.text = numberFormatter.string(from: NSNumber(value: crypto?.price ?? 0.0 ))
                cell.hourChange.text = String(format:"%.2f%%",crypto?.percent_change_1h ?? 0.0)
                cell.dayChange.text = String(format:"%.2f%%",crypto?.percent_change_24h ?? 0.0)
                cell.weekChange.text = String(format:"%.2f%%",crypto?.percent_change_7d ?? 0.0)
            
                cell.symbol.font = UIFont(name:"HelveticaNeue-Bold",size: 20.0)
                cell.price.font = UIFont(name:"HelveticaNeue-Bold",size: 20.0)
                cell.hourChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                cell.dayChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                cell.weekChange.font = UIFont(name:"HelveticaNeue-Bold",size: 18.0)
                
                setColor(label: cell.hourChange)
                setColor(label: cell.dayChange)
                setColor(label: cell.weekChange)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering{
            let selectedCrypto = [filteredCryptos[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        } else {
            let selectedCrypto = [fetchedResultsController.fetchedObjects?[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CryptoDetailViewController, let detailToSend = sender as? [Cryptocurrency] {
            vc.selectedFavoriteCrypto = detailToSend
        }
    }
    
}

extension FavoriteCryptoTableView: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            let adjustedIndexPath = IndexPath(row: newIndexPath.row, section: 0)
            tableView.insertRows(at: [adjustedIndexPath], with: .fade)
            if let firstIndexPath = tableView.indexPathsForVisibleRows?.first {
                tableView.reloadRows(at: [firstIndexPath], with: .fade)
            }
        default:
            break
        }
    }
}

//MARK: - Temporarily Removed Searchbar Feature

extension FavoriteCryptoTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarParams(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cryptocurrencies"
        //navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
