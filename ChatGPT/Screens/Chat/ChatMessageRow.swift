//
//  MessageRowView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 22-04-23.
//

import Splash
import SwiftUI
import UniformTypeIdentifiers

struct ChatMessageRow: View {
    @State private var textToBeSelected: String?
    @EnvironmentObject private var viewModel: ChatViewModel
    let chat: ChatMessage
    let fontSize: CGFloat
    private var theme: Theme {
        Theme.xcode(fontSize)
    }

    private func highlighter(isSwift: Bool) -> SyntaxHighlighter<AttributedStringOutputFormat> {
        SyntaxHighlighter(format: AttributedStringOutputFormat(theme: theme), grammar: isSwift ? SwiftGrammar() : NoGammar())
    }

    var body: some View {
        GroupBox {
            VStack(spacing: 0) {
                ForEach(chat.separatedMessages, id: \.self) { message in
                    let isCodeBlock = message.contains("```")
                    let isSwift = message.contains("```swift")
                    let proccesedMessage = message
                        .replacingOccurrences(of: "```", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    Text(
                        .init(isCodeBlock ? highlighter(isSwift: isSwift).highlight(proccesedMessage) : NSAttributedString(string: proccesedMessage))
                    )
                    .lineLimit(nil)
                    .font(.system(size: fontSize))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        #if os(macOS)
                        if isCodeBlock {
                            Button("Copiar código") {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(proccesedMessage, forType: .string)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                        #endif
                    }
                    .background {
                        if chat.isUser {
                            Color.clear
                        } else if isCodeBlock {
                            Color.black
                            // .cornerRadius(10)
                        } else {
                            Color.gray.opacity(0.4)
                        }
                    }
                    .textSelection(.enabled)
                    .contextMenu {
                        Button {
                            #if os(iOS)
                            let pasteboard = UIPasteboard.general
                            pasteboard.setValue(proccesedMessage, forPasteboardType: UTType.plainText.identifier)
                            #else
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(proccesedMessage, forType: .string)
                            #endif
                        } label: {
                            Label("Copiar", systemImage: "doc.on.doc")
                        }
                        Button {
                            viewModel.speakMessage(content: proccesedMessage)
                        } label: {
                            Label("Hablar", systemImage: "speaker.circle")
                        }
                        Button {
                            textToBeSelected = proccesedMessage
                        } label: {
                            Label("Seleccionar texto", systemImage: "selection.pin.in.out")
                        }
                    }
                }
            }
        } label: {
            Text(.init(chat.roleText))
        }
        .accessibilityElement()
        .accessibilityLabel(chat.isUser ? "Yo: \(chat.content)" : "CrackGPT: \(chat.content)")
        .padding(.bottom)
        #if os(iOS)
            .presentSelectableView($textToBeSelected)
        #endif
    }
}

#if os(iOS)

// MARK: Modifier for known bug in iOS 17 not presenting fullScreenCover.

// swiftformat:disable all
extension View {
    @ViewBuilder
    func presentSelectableView(_ selectableText: Binding<String?>) -> some View {
        if #available(iOS 17, *) {
            self
              .onChange(of: selectableText.wrappedValue) { currentText in
                  guard let currentText else { return }
                  let hostView = UIHostingController(rootView: ChatSelectableTextView(selectableText: currentText))
                  hostView.modalPresentationStyle = .overFullScreen
                  UIWindow.topMostViewController?.present(hostView, animated: true)
                  selectableText.wrappedValue = nil
              }
        } else {
            self
              .fullScreenCover(item: selectableText) { selectableText in
                  ChatSelectableTextView(selectableText: selectableText)
              }
        }
    }
}
// swiftformat:enable all
#endif
