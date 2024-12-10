//
//  HomeStatsView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 09/12/24.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stats: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}
