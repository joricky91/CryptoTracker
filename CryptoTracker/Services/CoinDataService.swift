//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 05/12/24.
//

import Foundation
import Combine

class CoinDataService {
    
//    @Published var allCoins: [CoinModel] = []
//    
//    var coinSubscription: AnyCancellable?
//    
//    init() {
//        getCoins()
//    }
//    
//    func getCoins() {
//        Task {
//            do {
//                let data = try
//            } catch {
//                
//            }
//        }
//        
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&x_cg_demo_api_key=CG-YwyoMnKemuRZMPAHeDMZqhWt") else { return }
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        
//        coinSubscription = NetworkingManager.download(url: url)
//            .decode(type: [CoinModel].self, decoder: decoder)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                NetworkingManager.handleCompletion(completion: completion)
//            } receiveValue: { [weak self] coins in
//                self?.allCoins = coins
//                self?.coinSubscription?.cancel()
//            }
//    }
    
}
