//
//  CryptoDetailViewControllerExtension.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/20/20.
//

import Foundation
import UIKit
import CoreData
import SDWebImage

extension CryptoDetailViewController{
    
    //MARK: - Functions
    
    func loadDetailData(){
        formatNumberData()
        formatStringData()
    }
    
    //MARK: - Number Formatting Function
    
    func formatNumberData(){
        numberFormatter.numberStyle = .currency
        let priceVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.price ?? 0.0))
        price.text = priceVar
        
        numberFormatter.maximumFractionDigits = 0
        let marketCapVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.market_cap ?? 0.0))
        let volumeVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.volume_24h ?? 0.0))
        marketCap.text = marketCapVar
        volume.text = volumeVar
        
        numberFormatter.numberStyle = .decimal
        let circSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.circulating_supply ?? 0))
        let totalSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.total_supply ?? 0.0))
        let maxSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.max_supply ?? 0.0))
        circSupply.text = "\(circSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? "N/A")"
        totalSupply.text = "\(totalSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? "N/A")"
        maxSupply.text = "\(maxSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? "N/A")"
    }
    
    //MARK: - String Formatting Function
    
    func formatStringData(){
        let rankVar = String(selectedCrypto.first?.cmc_rank ?? 0)
        let url = String(selectedCrypto.first?.logo ?? "N/A")
        let imageUrl:URL? = URL(string: url)
        logo.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "genericLogo.png"))
        name.text = selectedCrypto.first?.name
        symbol.text = "(\(selectedCrypto.first?.symbol ?? "N/A"))"
        dayChange.text = String(format:"(%.2f%%)", Float(selectedCrypto.first?.percent_change_24h ?? 0.0))
        setColor(label: dayChange)
        rank.text = "Rank \(rankVar)"
        textView.text = String(selectedCrypto.first?.description ?? "N/A")
    }
    
    func setColor(label: UILabel){
        if let text = label.text, let value = Float(text.filter("0123456789.-".contains)) {
            if value < 0{
                label.textColor = UIColor(red: 217/255, green: 65/255, blue: 55/255, alpha: 1.0)
            } else if value > 0{
                label.textColor = UIColor(red: 109/255, green: 191/255, blue: 165/255, alpha: 1.0)
            }
        }
    }
    
    //MARK: - Alert Functions
    
    func showLinkAlert(link: String){
        let alert:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.title = "\(link) Unavailable"
        alert.message = "\(selectedCrypto.first?.name ?? "N/A") doesn't have a \(link)."
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWatchlistAlert(){
        let alert:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.title = "Watchlist Error"
        alert.message = "Problem with watchlist functions."
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Watchlist Logic Functions
    
    func checkIfAddedToWatchlist(){
        let context = appDelegate.persistentContainer.viewContext
        let id = selectedCrypto.first?.id as! CVarArg
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cryptocurrency")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                addedToWatchlist = true
                addToWatchlistButton.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                addedToWatchlist = false
                addToWatchlistButton.image = UIImage(systemName: "plus.circle")
            }
        } catch {
            showWatchlistAlert()
        }
    }
    
    func addToWatchlist(){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cryptocurrency", in: context)
        let saveCrypto = NSManagedObject(entity: entity!, insertInto: context)
        
        saveCrypto.setValue(selectedCrypto.first?.id, forKey: "id")
        saveCrypto.setValue(selectedCrypto.first?.name, forKey: "name")
        saveCrypto.setValue(selectedCrypto.first?.symbol, forKey: "symbol")
        
        do {
            try context.save()
        } catch {
            print("Failed to Save!")
            showWatchlistAlert()
        }
    }
    
    func removeFromWatchlist(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cryptocurrency")
        
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]

            for item in items {
                if(item.value(forKey: "id") as? Int == selectedCrypto.first?.id){
                    context.delete(item)
                }
            }
            
            try context.save()

        } catch {
            showWatchlistAlert()
        }
    }
}
