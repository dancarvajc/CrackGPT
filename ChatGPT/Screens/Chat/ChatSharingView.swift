//
//  SharingChatView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import SwiftUI

struct ChatSharingView<Content: View>: View {
    @State private var showView = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            if showView {
                content()
                    .frame(width: 1, height: 1) // Save a ton of memory!!
            }
            VStack {
                #if os(iOS)
                Text(UIAccessibility.isVoiceOverRunning ? "Generando PDF del chat" : "¡Haciendo magia!")
                #else
                Text("¡Haciendo magia!")
                #endif
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Material.ultraThin)
            .accessibilityHidden(true)
            .onAppear {
                #if os(iOS)
                if UIAccessibility.isVoiceOverRunning {
                    UIAccessibility.post(notification: .screenChanged, argument: "Generando PDF del chat")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showView = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showView = true
                    }
                }
                #else
                DispatchQueue.main.async {
                    showView = true
                }
                #endif
            }
        }
    }
}
