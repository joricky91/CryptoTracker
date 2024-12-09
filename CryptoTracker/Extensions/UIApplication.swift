//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 09/12/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
