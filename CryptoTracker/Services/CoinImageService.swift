//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 06/12/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap { data -> UIImage? in
                return UIImage(data: data)
            }
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] image in
                self?.image = image
                self?.imageSubscription?.cancel()
            }
    }
    
}
