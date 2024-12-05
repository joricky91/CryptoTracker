//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 04/12/24.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(viewModel)
        }
    }
}
