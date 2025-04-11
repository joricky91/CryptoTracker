//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 12/12/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService()
//        self.addSubscribers()
    }
    
//    private func addSubscribers() {
//        coinDetailService.$coinDetails
//            .combineLatest($coin)
//            .map(mapDataToStatistics)
//            .sink { [weak self] returnedArrays in
//                self?.overviewStatistics = returnedArrays.overview
//                self?.additionalStatistics = returnedArrays.additional
//            }
//            .store(in: &cancellables)
//        
//        coinDetailService.$coinDetails
//            .sink { [weak self] returnedCoinDetails in
//                self?.coinDescription = returnedCoinDetails?.readableDescription
//                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
//                self?.redditURL = returnedCoinDetails?.links?.subredditURL
//                print(self?.coinDescription)
//            }
//            .store(in: &cancellables)
//    }
    
    private func mapDataToStatistics(coinDetail: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetail: coinDetail, coinModel: coinModel)

        return (overviewArray, additionalArray)
    }
    
    func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        let overviewArray: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
        
        return overviewArray
    }
    
    func createAdditionalArray(coinDetail: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? .zero
        let blockTimeString = blockTime == .zero ? "n/a" : String(blockTime)
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        let additionalArray: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
        
        return additionalArray
    }
    
}
