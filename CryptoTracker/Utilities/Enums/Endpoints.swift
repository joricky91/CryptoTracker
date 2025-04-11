//
//  Endpoints.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 11/04/25.
//

import Foundation

enum Endpoints {
    case global
    case markets(page: Int)
    case coinDetails(id: String)
    
    var path: String {
        switch self {
        case .global:
            "global"
        case .markets:
            "coins/markets"
        case .coinDetails(let id):
            "coins/\(id)"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .global:
            return nil
            
        case .markets(let page):
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "vs_currency", value: "usd"))
            items.append(URLQueryItem(name: "order", value: "market_cap_desc"))
            items.append(URLQueryItem(name: "per_page", value: "250"))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
            items.append(URLQueryItem(name: "sparkline", value: "true"))
            items.append(URLQueryItem(name: "price_change_percentage", value: "24h"))
            return items
            
        case .coinDetails:
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "localization", value: "false"))
            items.append(URLQueryItem(name: "tickers", value: "false"))
            items.append(URLQueryItem(name: "market_data", value: "false"))
            items.append(URLQueryItem(name: "community_data", value: "false"))
            items.append(URLQueryItem(name: "developer_data", value: "false"))
            items.append(URLQueryItem(name: "sparkline", value: "false"))
            return items
        }
    }
    
}
