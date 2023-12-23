//
//  LaunchScreen.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 11-11-23.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isLaunchScreenVisible = true

    var body: some View {
        ZStack {
            MainView()
                .preferredColorScheme(.dark)
            #if os(iOS)
            VStack {
                if isLaunchScreenVisible {
                    launchScreen
                        .transition(.move(edge: .top))
                }
            }.zIndex(1)
            #endif
        }
        .ignoresSafeArea()
    }

    var launchScreen: some View {
        ZStack {
            Color.black
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 128)
        }
        .onAppear {
            withAnimation(.bouncy.speed(0.8).delay(0.2)) {
                isLaunchScreenVisible = false
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
