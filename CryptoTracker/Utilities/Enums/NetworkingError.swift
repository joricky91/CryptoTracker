//
//  NetworkingError.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 11/04/25.
//

import Foundation

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
