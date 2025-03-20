//
//  String.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 05/02/25.
//

import Foundation

extension String {
    
    var removingHTMLOccurences: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
