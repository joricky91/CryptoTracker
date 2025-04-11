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
    private let fileManager = LocalFileManager.instance
    
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        Task {
            do {
                let data = try await NetworkingManager.shared.downloadImage(from: url)
                guard let downloadedImage = UIImage(data: data) else { return }
                self.image = downloadedImage
                self.fileManager.saveImage(image: downloadedImage,
                                           imageName: self.imageName,
                                           folderName: self.folderName)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
