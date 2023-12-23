//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 09-04-23.
//

import SwiftUI
#if os(iOS)
import IQKeyboardManagerSwift
#endif

@main
struct ChatGPTApp: App {
    #if os(iOS)
    init() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    #endif
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
        }
    }
}
