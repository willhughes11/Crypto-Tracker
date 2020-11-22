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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading{
            return 1
        } else {
            if isFiltering{
                return filteredCryptos.count
            } else {
                return cellData.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! TableCellView
        if loading {
        } else {
            if isFiltering{
                let crypto = filteredCryptos[indexPath.row]
                let imageUrl:URL? = URL(string: crypto.logo)
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
                let crypto = cellData[indexPath.row]
                let imageUrl:URL? = URL(string: crypto.logo)
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
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering{
            let selectedCrypto = [filteredCryptos[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        } else {
            let selectedCrypto = [cellData[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CryptoDetailViewController, let detailToSend = sender as? [TableCellData] {
            vc.selectedCrypto = detailToSend
        }
    }
}

extension FavoriteCryptoTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarParams(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cryptocurrencies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
