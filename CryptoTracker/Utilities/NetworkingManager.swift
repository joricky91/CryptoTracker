//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 06/12/24.
//

import Foundation
import Combine

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
