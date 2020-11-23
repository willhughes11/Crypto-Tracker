//
//  CoinMarketClient.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import Foundation
import UIKit

class CMCClient {
    
    var cryptoTrackerId: [String] = []
    var numString: String = ""
    var cryptoLogo: UIImage!
    
    struct Auth {
        static let key: String = "664d22ac-4c54-42a0-86d5-13b8239469d3"
        static let testKey: String = "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c"
    }
    
    enum Endpoints {
        
        static let base = "https://pro-api.coinmarketcap.com/v1/cryptocurrency"
        static let testBase = "https://sandbox-api.coinmarketcap.com/v1/cryptocurrency"
        
        case allCrytptos
        case cryptoDetails(String)
        case cryptoQuoteLatest(String)
        
        var stringValue: String {
            switch self {
            case .allCrytptos: return
                "\(Endpoints.base)/map?CMC_PRO_API_KEY=\(Auth.key)&limit=1250&sort=cmc_rank"
            case .cryptoDetails(let id): return
                "\(Endpoints.base)/info?CMC_PRO_API_KEY=\(Auth.key)&id=\(id)"
            case .cryptoQuoteLatest(let id): return
                "\(Endpoints.base)/quotes/latest?CMC_PRO_API_KEY=\(Auth.key)&id=\(id)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    func getAllCryptoIds(completionHandler: @escaping ([String]?, Error?) -> Void){
        let request = URLRequest(url: Endpoints.allCrytptos.url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [self] data, response, error in
        guard let data = data, error == nil else {
            return
        }
        
        var result: CoinMarketCapIdMap?
        do {
            result = try JSONDecoder().decode(CoinMarketCapIdMap.self, from: data)
            guard let json = result else {
                return
            }
            for i in 0...json.data.count{
                if(cryptoTrackerId.count < json.data.count){
                cryptoTrackerId.append(String(json.data[i].id))
                }
            }

            
            DispatchQueue.main.async {
                completionHandler(cryptoTrackerId, nil)
            }
            
        } catch {
            DispatchQueue.main.async {
                completionHandler(nil, error)
                print("Error: \(error.localizedDescription)")
            }
        }
        })
        task.resume()
    }
    
    func allCryptoDetails(completionHandler: @escaping (Metadata?, Error?) -> Void){
        self.getAllCryptoIds(){ [self]data,error in
            cryptoTrackerId = data ?? ["1"]
        let cryptoString = cryptoTrackerId.joined(separator: ",")
        let request = URLRequest(url: Endpoints.cryptoDetails(cryptoString).url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, resonse, error in
            guard let data = data, error == nil else {
                return
            }
            var result: Metadata?
            do {
                result = try JSONDecoder().decode(Metadata.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(result, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                    print("Error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
        }
    }
    
    func getCryptoQuoteData(completionHandler: @escaping (QuoteLatest?, Error?) -> Void){
        self.getAllCryptoIds(){ [self]data,error in
            cryptoTrackerId = data ?? ["1"]
            let cryptoString = cryptoTrackerId.joined(separator: ",")
            let request = URLRequest(url: Endpoints.cryptoQuoteLatest(cryptoString).url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                var result: QuoteLatest?
                do {
                    result = try JSONDecoder().decode(QuoteLatest.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(result, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                        print("Error: \(error)")
                    }
                }
            })
            task.resume()
        }
    }
    
    func getTableCellData(completionHandler: @escaping ([TableCellData], Error?) -> Void){
        var cellData = [TableCellData]()
        self.getAllCryptoIds(){idData,error in
            self.cryptoTrackerId = idData ?? ["1"]
            self.allCryptoDetails(){detailData, error in
                self.getCryptoQuoteData(){quoteData, error in
                    for i in 0...self.cryptoTrackerId.count-1{
                        self.numString = String(self.cryptoTrackerId[i])
                                let data = TableCellData(id: Int(detailData?.data[self.numString]?.id ?? 0),
                                                         symbol: String(detailData?.data[self.numString]?.symbol ?? "N/A"),
                                                         name: String(detailData?.data[self.numString]?.name ?? "N/A"),
                                                         logo: String(detailData?.data[self.numString]?.logo ?? "N/A"),
                                                         description: detailData?.data[self.numString]?.description ?? "N/A",
                                                         cmc_rank: Int(quoteData?.data[self.numString]?.cmc_rank ?? 0),
                                                         website: String(detailData?.data[self.numString]?.urls?.website?.first ?? "N/A"),
                                                         source_code: String(detailData?.data[self.numString]?.urls?.source_code?.first ?? "N/A"),
                                                         message_board: String(detailData?.data[self.numString]?.urls?.message?.first ?? "N/A"),
                                                         technical_doc: String(detailData?.data[self.numString]?.urls?.technical_doc?.first ?? "N/A"),
                                                         category: String(detailData?.data[self.numString]?.category ?? "N/A"),
                                                         circulating_supply: Int(quoteData?.data[self.numString]?.circulating_supply ?? 0),
                                                         price: Float(quoteData?.data[self.numString]?.quote["USD"]?.price ?? 0.0),
                                                         volume_24h: Float(quoteData?.data[self.numString]?.quote["USD"]?.volume_24h ?? 0.0),
                                                         percent_change_1h: Float(quoteData?.data[self.numString]?.quote["USD"]?.percent_change_1h ?? 0.0),
                                                         percent_change_24h: Float(quoteData?.data[self.numString]?.quote["USD"]?.percent_change_24h ?? 0.0),
                                                         percent_change_7d: Float(quoteData?.data[self.numString]?.quote["USD"]?.percent_change_7d ?? 0.0),
                                                         market_cap: Float(quoteData?.data[self.numString]?.quote["USD"]?.market_cap ?? 0.0),
                                                         max_supply: Float(quoteData?.data[self.numString]?.max_suppy ?? 0.0),
                                                         total_supply: Float(quoteData?.data[self.numString]?.total_supply ?? 0.0))
                                cellData.append(data)
                                }
                    completionHandler(cellData, nil)
                }
            }
        }
    }
    
    }
