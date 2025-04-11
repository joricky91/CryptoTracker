//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 06/12/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let service: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.service = CoinImageService(coin: coin)
        addSubscribers()
        isLoading = true
    }
    
    private func addSubscribers() {
        service.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
    
}
