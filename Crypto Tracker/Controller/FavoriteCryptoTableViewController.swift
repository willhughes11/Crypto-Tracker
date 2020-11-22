//
//  FavoriteCryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import Foundation
import UIKit
import CoreData

class FavoriteCryptoTableView: UITableViewController {
    
    let CryptoClient = CMCClient()
    let numberFormatter = NumberFormatter()
    
    var cellData = [TableCellData]()
    var loading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getWatchlistCryptos()
        loadTableCell()
        tableView.reloadData()
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var watchlistIds: [Int] = []
    
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
            
            //let id = self.cellData.map{$0.id}
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
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if loading{
                return 1
            } else {
                return cellData.count
            }
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! TableCellView
            if loading {
            } else {
                let crypto = cellData[indexPath.row]
                //cell.logo.image = crypto.logo
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
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedCrypto = [cellData[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? CryptoDetailViewController, let detailToSend = sender as? [TableCellData] {
                vc.selectedCrypto = detailToSend
            }
        }
}
