//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 12/12/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    titleText(text: "Overview")
                    Divider()
                    
                    descriptionSection
                    
                    gridView(items: viewModel.overviewStatistics)
                    
                    titleText(text: "Additional Details")
                    
                    Divider()
                    
                    gridView(items: viewModel.additionalStatistics)
                    
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
}

extension DetailView {
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let websiteString = viewModel.websiteURL, let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = viewModel.redditURL, let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let description = viewModel.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private func titleText(text: String) -> some View {
        Text(text)
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func gridView(items: [StatisticModel]) -> some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(items) { stat in
                StatisticView(stats: stat)
            }
        }
    }
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
}
