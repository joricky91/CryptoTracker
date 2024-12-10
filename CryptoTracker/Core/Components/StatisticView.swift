//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 09/12/24.
//

import SwiftUI

struct StatisticView: View {
    
    let stats: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stats.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stats.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stats.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stats.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stats.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stats.percentageChange == nil ? 0 : 1)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatisticView(stats: DeveloperPreview.instance.stats1)
        .colorScheme(.dark)
    
    StatisticView(stats: DeveloperPreview.instance.stats2)
    
    StatisticView(stats: DeveloperPreview.instance.stats3)
        .colorScheme(.dark)
}
