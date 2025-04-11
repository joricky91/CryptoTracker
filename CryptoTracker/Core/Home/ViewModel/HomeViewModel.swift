//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 05/12/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init () {
        reloadData()
        addSubscribers()
    }
    
    func addSubscribers() {
        portfolioDataService.$savedEntities
            .map(mapPortfolioCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
//        $searchText
//            .combineLatest(coinDataService.$allCoins, $sortOption)
//            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
//            .map(filterAndSortCoins)
//            .sink { [weak self] coins in
//                self?.allCoins = coins
//            }
//            .store(in: &cancellables)
//        
//        // Updates portfolio coins
//        $allCoins
//            .combineLatest(portfolioDataService.$savedEntities)
//            .map(mapPortfolioCoins)
//            .sink { [weak self] coins in
//                guard let self else { return }
//                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
//            }
//            .store(in: &cancellables)
//        
//        // Updates market data
//        marketDataService.$marketData
//            .combineLatest($portfolioCoins)
//            .map(mapGlobalMarketData)
//            .sink { [weak self] stats in
//                self?.statistics = stats
//            }
//            .store(in: &cancellables)
    }
    
    func getAllCoins() {
        Task {
            do {
                var coins: [CoinModel] = try await NetworkingManager.shared.getData(from: .markets(page: 1))
                sortCoins(sort: sortOption, coins: &coins)
                DispatchQueue.main.async {
                    self.allCoins = coins
                    let portfolioData = self.portfolioDataService.savedEntities
                    self.portfolioCoins = self.mapPortfolioCoins(portfolio: portfolioData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getMarketData() {
        Task {
            do {
                let stats: GlobalData = try await NetworkingManager.shared.getData(from: .global)
                let statsMapped = mapGlobalMarketData(data: stats.data, portfolioCoins: portfolioCoins)
                DispatchQueue.main.async { self.statistics = statsMapped }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        getAllCoins()
        getMarketData()
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    private func mapPortfolioCoins(portfolio: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolio.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data else { return stats }
        stats.append(StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd))
        stats.append(StatisticModel(title: "24h Volume", value: data.volume))
        stats.append(StatisticModel(title: "BTC Dominance", value: data.btcDominance))
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        
        let previousValue =
        portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? .zero) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        stats.append(StatisticModel(title: "Portfolio Value",
                                    value: portfolioValue.asCurrencyWith2Decimals(),
                                    percentageChange: percentageChange))
        
        return stats
    }
    
}
