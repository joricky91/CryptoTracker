//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 12/12/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        Text(viewModel.coinDetails?.name ?? "")
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
