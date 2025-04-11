//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 06/12/24.
//

import Foundation
import Combine

enum Endpoints {
    
    case global
    case markets(page: Int)
    case coinDetails(id: Int)
    
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

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(let url):
            return "[🔥] Bad response from URL: \(url)"
        case .unknown:
            return "[⚠️] Unknown error occured"
        }
    }
}

class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private let baseURL = "https://api.coingecko.com/api/v3/"
    private let decoder = JSONDecoder()
    private let session = URLSession(configuration: .ephemeral)
    
    typealias NetworkResponse = (data: Data, response: URLResponse)
    
    func getData<T: Codable>(from endpoint: Endpoints) async throws -> T {
        let request = try createRequest(endpoint: endpoint)
        let response: NetworkResponse = try await session.data(for: request)
        
        guard let url = request.url else { throw NetworkingError.unknown }
        try handleURLResponse(response, for: url)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: response.data)
    }
    
    func downloadImage(from url: URL) async throws -> Data {
        let response: NetworkResponse = try await session.data(from: url)
        try handleURLResponse(response, for: url)
        
        return response.data
    }
    
    private func handleURLResponse(_ response: NetworkResponse, for url: URL) throws {
        guard let httpResponse = response.response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkingError.badURLResponse(url: url)
        }
    }
    
}

extension NetworkingManager {
    
    private func createRequest(endpoint: Endpoints) throws -> URLRequest {
        guard let path = URL(string: baseURL.appending(endpoint.path)), var components = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            throw NetworkingError.unknown
        }
        
        if let parameters = endpoint.parameters {
            components.queryItems = parameters
        }
        
        guard let url = components.url else { throw NetworkingError.unknown }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("CG-YwyoMnKemuRZMPAHeDMZqhWt", forHTTPHeaderField: "x_cg_demo_api_key")
        
        return request
    }
    
}
