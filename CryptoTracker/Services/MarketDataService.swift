//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 10/12/24.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global?x_cg_demo_api_key=CG-PLYqVLcYDeZSGKWPUH3KHT2q") else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: decoder)
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] global in
                self?.marketData = global.data
                self?.marketDataSubscription?.cancel()
            }
    }
    
}
