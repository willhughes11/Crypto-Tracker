//
//  CryptoDetailViewController.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/15/20.
//

import Foundation
import UIKit
import CoreData

class CryptoDetailViewController: UIViewController {
    
    var selectedCrypto = [TableCellData]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfAddedToWatchlist()
        loadDetailData()
    }
    
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
        if let url = NSURL(string: selectedCrypto.first?.website ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Website"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func messageBoardLink(_ sender: Any) {
        if let url = NSURL(string: selectedCrypto.first?.message_board ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Message Board"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func sourceCodeLink(_ sender: Any) {
        if let url = NSURL(string: selectedCrypto.first?.source_code ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Source Code Page"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func technicalDocumentationLink(_ sender: Any) {
        if let url = NSURL(string: selectedCrypto.first?.technical_doc ?? "N/A"){
            if(url == NSURL(string: "N/A")){
                let link = "Technical Document"
                showLinkAlert(link: link)
            } else {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
