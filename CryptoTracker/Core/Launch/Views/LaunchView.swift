//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Jonathan Ricky Sandjaja on 08/04/25.
//

import SwiftUI

struct LaunchView: View {
    @State private var counter: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showLaunchView.toggle()
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
