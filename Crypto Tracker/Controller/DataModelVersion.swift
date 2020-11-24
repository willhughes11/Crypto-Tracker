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
//MARK - CryptoDetailViewController
/*
import Foundation
import UIKit
import CoreData

class CryptoDetailViewController: UIViewController {
    
    // MARK: - Properties: Variables and Constants
    
    var selectedCrypto = [TableCellData]()
    var selectedFavoriteCrypto = [Cryptocurrency]()
    var addedToWatchlist = false
    
    let numberFormatter = NumberFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet var dayChange: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var circSupply: UILabel!
    @IBOutlet weak var totalSupply: UILabel!
    @IBOutlet weak var maxSupply: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var rank: UITextView!
    @IBOutlet weak var addToWatchlistButton: UIBarButtonItem!
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfAddedToWatchlist()
        loadDetailData()
    }
    
    //MARK: - IBActions
    
    @IBAction func addCryptoToWatchlist(_ sender: UIBarButtonItem) {
        if addedToWatchlist == false {
            addToWatchlist()
            addedToWatchlist = true
            addToWatchlistButton.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            removeFromWatchlist()
            addedToWatchlist = false
            addToWatchlistButton.image = UIImage(systemName: "plus.circle")
        }
    }
    
    @IBAction func websiteLink(_ sender: Any) {
        if let url = NSURL(string: (selectedCrypto.first?.website ?? selectedFavoriteCrypto.first?.website) ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Website"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func messageBoardLink(_ sender: Any) {
        if let url = NSURL(string: (selectedCrypto.first?.message_board ?? selectedFavoriteCrypto.first?.message_board) ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Message Board"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func sourceCodeLink(_ sender: Any) {
        if let url = NSURL(string: (selectedCrypto.first?.source_code ?? selectedFavoriteCrypto.first?.source_code) ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Source Code Page"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func technicalDocumentationLink(_ sender: Any) {
        if let url = NSURL(string: (selectedCrypto.first?.technical_doc ?? selectedFavoriteCrypto.first?.technical_doc) ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Technical Document"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
*/
//MARK - CryptoDetailViewController
/*
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
        let priceVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.price ?? Float(selectedFavoriteCrypto.first?.price ?? 0.0)))
        price.text = priceVar
        
        numberFormatter.maximumFractionDigits = 0
        let marketCapVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.market_cap ?? Float(selectedFavoriteCrypto.first?.market_cap ?? 0.0)))
        let volumeVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.volume_24h ?? Float(selectedFavoriteCrypto.first?.volume_24h ?? 0.0)))
        marketCap.text = marketCapVar
        volume.text = volumeVar
        
        numberFormatter.numberStyle = .decimal
        let circSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.circulating_supply ?? Int(selectedFavoriteCrypto.first?.market_cap ?? 0)))
        let totalSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.total_supply ?? Float(selectedFavoriteCrypto.first?.total_supply ?? 0.0)))
        let maxSupplyVar = numberFormatter.string(from: NSNumber(value: selectedCrypto.first?.max_supply ?? Float(selectedFavoriteCrypto.first?.max_supply ?? 0.0)))
        circSupply.text = "\(circSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? selectedFavoriteCrypto.first?.symbol ?? "N/A")"
        totalSupply.text = "\(totalSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? selectedFavoriteCrypto.first?.symbol ?? "N/A")"
        maxSupply.text = "\(maxSupplyVar ?? "0") \(selectedCrypto.first?.symbol ?? selectedFavoriteCrypto.first?.symbol ?? "N/A")"
    }
    
    //MARK: - String Formatting Function
    
    func formatStringData(){
        let rankVar = String(selectedCrypto.first?.cmc_rank ?? Int(selectedFavoriteCrypto.first?.cmc_rank ?? 0))
        let url = String((selectedCrypto.first?.logo ?? selectedFavoriteCrypto.first?.logo) ?? "N/A")
        let imageUrl:URL? = URL(string: url)
        logo.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "genericLogo.png"))
        name.text = selectedCrypto.first?.name ?? selectedFavoriteCrypto.first?.name
        symbol.text = "(\(selectedCrypto.first?.symbol ?? selectedFavoriteCrypto.first?.symbol ?? "N/A"))"
        dayChange.text = String(format:"(%.2f%%)", Float((selectedCrypto.first?.percent_change_24h ?? selectedFavoriteCrypto.first?.percent_change_24h) ?? 0.0) )
        setColor(label: dayChange)
        rank.text = "Rank \(rankVar)"
        textView.text = String((selectedCrypto.first?.description ?? selectedFavoriteCrypto.first?.description) ?? "N/A")
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
        let id = selectedCrypto.first?.id ?? Int(selectedFavoriteCrypto.first?.id ?? 0)
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
        saveCrypto.setValue(selectedCrypto.first?.category, forKey: "category")
        saveCrypto.setValue(selectedCrypto.first?.circulating_supply, forKey: "circ_supply")
        saveCrypto.setValue(selectedCrypto.first?.cmc_rank, forKey: "cmc_rank")
        saveCrypto.setValue(selectedCrypto.first?.logo, forKey: "logo")
        saveCrypto.setValue(selectedCrypto.first?.market_cap, forKey: "market_cap")
        saveCrypto.setValue(selectedCrypto.first?.max_supply, forKey: "max_supply")
        saveCrypto.setValue(selectedCrypto.first?.message_board, forKey: "message_board")
        saveCrypto.setValue(selectedCrypto.first?.percent_change_1h, forKey: "percent_change_1h")
        saveCrypto.setValue(selectedCrypto.first?.percent_change_24h, forKey: "percent_change_24h")
        saveCrypto.setValue(selectedCrypto.first?.percent_change_7d, forKey: "percent_change_7d")
        saveCrypto.setValue(selectedCrypto.first?.price, forKey: "price")
        saveCrypto.setValue(selectedCrypto.first?.source_code, forKey: "source_code")
        saveCrypto.setValue(selectedCrypto.first?.description, forKey: "summary")
        saveCrypto.setValue(selectedCrypto.first?.technical_doc, forKey: "technical_doc")
        saveCrypto.setValue(selectedCrypto.first?.total_supply, forKey: "total_supply")
        saveCrypto.setValue(selectedCrypto.first?.volume_24h, forKey: "volume_24h")
        saveCrypto.setValue(selectedCrypto.first?.website, forKey: "website")
        
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
                if(item.value(forKey: "id") as? Int == selectedCrypto.first?.id ?? Int(selectedFavoriteCrypto.first?.id ?? 0)){
                    context.delete(item)
                }
            }
            
            try context.save()

        } catch {
            showWatchlistAlert()
        }
    }
}
*/
