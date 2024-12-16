//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 12/12/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var coinDetails: CoinDetailModel?
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { coinDetail in
                print("Received coin detail data")
                print(coinDetail)
            }
            .store(in: &cancellables)
    }
    
}
