//
//  NSTextViewUI+.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 04-12-23.
//
#if os(macOS)
import SwiftUI

struct NSTextViewUI: NSViewRepresentable {
    @Binding var text: String
    let isDisabled: Bool
    let onEnterKey: () -> Void

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        guard let textView = scrollView.documentView as? NSTextView else {
            return scrollView
        }
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 18)

        // MARK: Not sure if it can be used in prod

        let attributes: [NSAttributedString.Key: Any] =
            [
                .foregroundColor: NSColor.secondaryLabelColor,
                .font: NSFont.systemFont(ofSize: 18),
            ]
        textView.setValue(NSAttributedString(string: "Mensaje", attributes: attributes), forKey: "placeholderAttributedString")
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context _: Context) {
        guard let textView = nsView.documentView as? NSTextView else {
            return
        }
        textView.textColor = isDisabled ? .secondaryLabelColor : .white
        guard textView.string != text else { return }
        textView.string = text
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        private let parent: NSTextViewUI

        init(_ parent: NSTextViewUI) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            parent.text = textView.string
        }

        func textView(_: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSTextView.insertNewline(_:)) {
                if let event = NSApplication.shared.currentEvent,
                   !event.modifierFlags.contains(.shift)
                {
                    parent.onEnterKey()
                    return true
                }
            }
            return false
        }
    }
}
#endif
