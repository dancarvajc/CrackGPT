//
//  ChatSelectableTextView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 24-11-23.
//

import SwiftUI
import SwiftUIIntrospect

#if os(iOS)
struct ChatSelectableTextView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isFirstTime = true
    let selectableText: String

    var body: some View {
        NavigationView {
            TextEditor(text: .constant(selectableText))
                .introspect(.textEditor, on: .iOS(.v15)) { textView in
                    DispatchQueue.main.async {
                        textView.alwaysBounceVertical = false
                        textView.alwaysBounceHorizontal = false
                        textView.isEditable = false
                        textView.contentInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
                        textView.setContentOffset(CGPoint(x: textView.contentOffset.x, y: -textView.safeAreaInsets.top), animated: false)
                    }
                }
                .introspect(.textEditor, on: .iOS(.v16, .v17)) { textView in
                    textView.alwaysBounceVertical = false
                    textView.alwaysBounceHorizontal = false
                    textView.isEditable = false
                    textView.contentInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Selecciona el texto")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Cerrar", systemImage: "xmark.circle") {
                            dismiss()
                        }.buttonStyle(.plain)
                    }
                }
        }
        .navigationViewStyle(.stack)
        .introspect(.navigationView(style: .stack), on: .iOS(.v15, .v16, .v17)) { navbar in
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithDefaultBackground()
            navbar.navigationBar.compactAppearance = coloredAppearance
            navbar.navigationBar.standardAppearance = coloredAppearance
            navbar.navigationBar.scrollEdgeAppearance = coloredAppearance
            navbar.navigationBar.compactScrollEdgeAppearance = coloredAppearance
        }
    }
}
#endif
