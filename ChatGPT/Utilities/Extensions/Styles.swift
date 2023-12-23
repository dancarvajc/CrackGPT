//
//  Styles.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 11-11-23.
//

import Splash
import SwiftUI

struct MyCustomMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(.white)
            .padding(8)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 50)
            .background(Color.blue.cornerRadius(10))
    }
}

// Splash Syntax when the language is not Swift
struct NoGammar: Grammar {
    var delimiters: CharacterSet = .init()
    var syntaxRules = [Splash.SyntaxRule]()
}
