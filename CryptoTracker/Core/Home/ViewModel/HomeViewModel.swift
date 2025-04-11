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
    
    @Published private var originalCoins: [CoinModel] = []
    @Published private var originalPortfolio: [CoinModel] = []
    
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
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
        
        $searchText
            .combineLatest($sortOption)
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = self.filterAndSortCoins()
                self.portfolioCoins = self.filterAndSortCoins(isPortfolio: true)
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        getAllCoins()
        getMarketData()
    }
    
    func getAllCoins() {
        Task {
            do {
                var coins: [CoinModel] = try await NetworkingManager.shared.getData(from: .markets(page: 1))
                sortCoins(coins: &coins)
                DispatchQueue.main.async {
                    self.allCoins = coins
                    self.originalCoins = coins
                    let portfolioData = self.portfolioDataService.savedEntities
                    let mappedPortfolio = self.mapPortfolioCoins(portfolio: portfolioData)
                    self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: mappedPortfolio)
                    self.originalPortfolio = self.sortPortfolioCoinsIfNeeded(coins: mappedPortfolio)
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

//MARK: - Portfolio
extension HomeViewModel {
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
}

//MARK: - Filter & Sort
extension HomeViewModel {
    
    private func filterAndSortCoins(isPortfolio: Bool = false) -> [CoinModel] {
        var updatedCoins = filterCoins(text: searchText, coins: isPortfolio ? originalPortfolio : originalCoins)
        sortCoins(coins: &updatedCoins)
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
    
    private func sortCoins(coins: inout [CoinModel]) {
        switch sortOption {
        case .rank:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        case .holdings:
            coins.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            coins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
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
    
}
