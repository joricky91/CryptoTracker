//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 08/04/25.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(staticString: "https://www.google.com")
    let youtubeURL = URL(staticString: "https://youtube.com/c/swiftfulthinking")
    let coffeeURL = URL(staticString: "https://www.buymeacoffee.com/nicksarno")
    let coingeckoURL = URL(staticString: "https://www.coingecko.com")
    let personalURL = URL(staticString: "https://github.com/joricky91")
    
    var body: some View {
        NavigationStack {
            List {
                swiftfulThinkingSection
                
                coinGeckoSection
                
                developerSection
                
                applicationSection
            }
            .listStyle(.grouped)
            .font(.headline)
            .accentColor(.blue)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var swiftfulThinkingSection: some View {
        Section {
            VStackLayout(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by following a @SwiftfulThinking course on Youtube. It uses MVVM Architecture, Combine, and CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on Youtube 🥳", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeeURL)
        } header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStackLayout(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: UIScreen.main.bounds.height / 9)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko. Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko 🥳", destination: coingeckoURL)
        } header: {
            Text("Coin Gecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStackLayout(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developer by Jonathan Ricky Sandjaja using SwiftUI, and it is written 100% in Swift langugage. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit Github 🥳", destination: personalURL)
        } header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
    
}

extension URL {
    init(staticString: StaticString) {
        guard let url = Self(string: "\(staticString)") else {
            fatalError("Invalid static URL string: \(staticString)")
        }

        self = url
    }
}
