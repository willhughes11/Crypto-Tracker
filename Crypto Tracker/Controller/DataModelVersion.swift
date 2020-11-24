//MARK - FavoriteCryptoTableViewController
/*import Foundation
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
        //searchBarParams()
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
    }/*
//MARK - FavoriteCryptoTableView Extensions
import Foundation
import UIKit
import CoreData

extension FavoriteCryptoTableView {
    
    //MARK: - Override Table View Functions
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if isFiltering{
            print(filteredCryptos.count)
            return filteredCryptos.count
        } else {*/
            return fetchedResultsController.fetchedObjects?.count ?? 0
        //}
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! TableCellView
        /*if loading {
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
            } else {*/
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
            //}
        //}
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if isFiltering{
            let selectedCrypto = [filteredCryptos[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        } else {*/
            let selectedCrypto = [fetchedResultsController.fetchedObjects?[indexPath.row]]
            self.performSegue(withIdentifier: "selectedCrypto", sender: selectedCrypto)
        //}
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
/*
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
*/
