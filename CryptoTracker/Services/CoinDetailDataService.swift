//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 12/12/24.
//

import Foundation
import Combine

class CoinDetailDataService {
    
//    @Published var coinDetails: CoinDetailModel?
//    
//    var coinDetailSubscription: AnyCancellable?
//    let coin: CoinModel
//    
//    init(coin: CoinModel) {
//        self.coin = coin
//        getCoinDetails()
//    }
//    
//    func getCoinDetails() {
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false&x_cg_demo_api_key=CG-YwyoMnKemuRZMPAHeDMZqhWt") else { return }
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        
//        coinDetailSubscription = NetworkingManager.download(url: url)
//            .decode(type: CoinDetailModel.self, decoder: decoder)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                NetworkingManager.handleCompletion(completion: completion)
//            } receiveValue: { [weak self] coinDetail in
//                self?.coinDetails = coinDetail
//                self?.coinDetailSubscription?.cancel()
//            }
//    }
    
}
