//
//  TextEditorView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 18-07-23.
//

import SwiftUI

struct TextEditorView: View {
    @State private var textEditorHeight: CGFloat
    @State private var textHeight: CGFloat = 0
    @State private var numberOfLines: Int = 0
    @Binding private var string: String
    private let placeholder: String
    private let minHeight: CGFloat
    private let lineLimit: Int
    private let textSize: CGFloat
    private let forceLineLimit: Bool

    init(text: Binding<String>, placeholder: String = "", minHeight: CGFloat = 35, maxLinesDisplayed: Int = 5, textSize: CGFloat = 10, forceLineLimit: Bool = false) {
        self._string = text
        self._textEditorHeight = State(wrappedValue: minHeight)
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.lineLimit = maxLinesDisplayed
        self.textSize = textSize
        self.forceLineLimit = forceLineLimit
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(string.isEmpty ? placeholder : "" + string)
                .font(.system(size: textSize))
                .lineLimit(lineLimit)
                .multilineTextAlignment(.leading)
                .padding([.top, .trailing], 3)
                .frame(alignment: .topLeading)
                .bindDimension(.height, to: $textEditorHeight)
                .background {
                    Text(string)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: textSize))
                        .multilineTextAlignment(.leading)
                        .bindDimension(.height, to: $textHeight)
                        .hidden()
                }
                .accessibilityHidden(true)
            TextEditor(text: $string)
                .font(.system(size: textSize))
                .padding(-5)
                .multilineTextAlignment(.leading)
                .opacity(string.isEmpty ? 0.5 : 1)
                .frame(height: textEditorHeight < minHeight ? minHeight : textEditorHeight, alignment: .topLeading)
        }
        .onChange(of: string) { _ in
            guard forceLineLimit else { return }
            if numberOfLines > lineLimit {
                string.removeLast()
            }
        }
        .onChange(of: textHeight) { newHeight in
            let linesNumber = Int(newHeight / (textSize + 3).rounded(.down))
            numberOfLines = linesNumber
        }
    }
}

struct TextEditorViewTest: View {
    @State private var text = "Test"
    var body: some View {
        TextEditorView(text: $text, placeholder: "placeholder", minHeight: 35)
            .padding()
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorViewTest()
    }
}
