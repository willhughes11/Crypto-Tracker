//
//  CMCResponse.swift
//  Crypto Tracker
//
//  Created by William K Hughes on 11/9/20.
//

import Foundation
import UIKit

// MARK: Responses
struct CoinMarketCapIdMap: Codable {
    let status: Status
    let data: [AllCryptoData]
}

struct Metadata: Codable {
    let status: Status
    let data: [String:CryptoDetail]
}

struct QuoteLatest: Codable {
    let status: Status
    let data: [String:CryptoQuoteData]
}

struct TableCellData{
    let id: Int
    let symbol: String
    let name: String
    let logo: String
    let description: String
    let cmc_rank: Int
    let website: String
    let source_code: String
    let message_board: String
    let technical_doc: String
    let category: String
    let circulating_supply: Int
    let price: Float
    let volume_24h: Float
    let percent_change_1h: Float
    let percent_change_24h: Float
    let percent_change_7d: Float
    let market_cap: Float
    let max_supply: Float
    let total_supply: Float
}

// MARK: Sub-Responses
struct AllCryptoData: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let is_active: Int
    let status: String?
    let first_historical_data: String?
    let last_historical_data: String?
    let platform: Platform?
}

struct CryptoDetail: Codable {
    let urls: URLS?
    let id: Int
    let name: String
    let symbol: String
    let category: String
    let slug: String
    let logo: String
    let description: String
    let date_added: String
    let notice: String?
    let tags: [String]?
    let date_launched: String?
    let platform: Platform?
}

struct CryptoQuoteData: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let is_active: Int
    let is_fiat: Int
    let circulating_supply: Float?
    let total_supply: Float?
    let max_suppy: Float?
    let date_added: String
    let num_market_pairs: Int
    let cmc_rank: Int
    let last_updated: String
    let tags: [String]
    let platform: Platform?
    let quote: [String:Quote]
}

struct Platform: Codable {
        let id: Int
        let name: String
        let symbol: String
        let slug: String
        let token_address: String
}

struct URLS: Codable {
    let website: [String]?
    let technical_doc: [String]?
    let twitter: [String]?
    let reddit: [String]?
    let message: [String]?
    let announcement: [String]?
    let chat: [String]?
    let explorer: [String]?
    let source_code: [String]?
}

struct Quote: Codable {
    let price: Float
    let volume_24h: Float?
    let percent_change_1h: Float?
    let percent_change_24h: Float?
    let percent_change_7d: Float?
    let market_cap: Float?
    let last_updated: String
}

struct Status: Codable {
    let timestamp: String?
    let error_code: Int?
    let error_message: String?
    let elapsed: Int?
    let credit_count: Int?
}
