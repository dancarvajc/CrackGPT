//
//  GPTPersonalityView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 20-08-23.
//

import SwiftUI

struct GPTPersonalityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var titleText: String
    @State private var descriptionText: String
    private let viewModel: GPTPersonalityViewModel
    private let isEditing: Bool
    private let personality: GPTPersonality?

    init(_ model: GPTPersonality? = nil,
         viewModel: GPTPersonalityViewModel)
    {
        self.personality = model
        _titleText = State(wrappedValue: model?.name ?? "")
        _descriptionText = State(wrappedValue: model?.description ?? "")
        self.viewModel = viewModel
        self.isEditing = model != nil
    }

    var body: some View {
        content
        #if os(macOS)
        .frame(minWidth: 500)
        #endif
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private extension GPTPersonalityView {
    var content: some View {
        Form {
            gptTitleView
            gptPersonalityView
        }
        .toolbar {
            toolbarView
        }
    }

    @ToolbarContentBuilder
    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Nueva personalidad")
                    .font(.headline)
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Listo", action: saveGPTPersonality)
                .disabled(descriptionText.isEmpty || titleText.isEmpty)
        }
        ToolbarItem(placement: .cancellationAction) {
            #if os(macOS)
            Button("Cancelar") {
                dismiss()
            }
            #else
            if !isEditing {
                Button("Cancelar") {
                    dismiss()
                }
            }
            #endif
        }
    }

    var gptTitleView: some View {
        Section {
            TextField("", text: $titleText, prompt: Text("Nutria"))
                .font(.system(size: 18))
        } header: {
            Text("Título de la personalidad")
        }
    }

    var gptPersonalityView: some View {
        Section {
            TextEditorView(
                text: $descriptionText,
                placeholder: "Eres una nutria que me responde de forma divertida...",
                minHeight: 100,
                maxLinesDisplayed: 15,
                textSize: 18
            )
        } header: {
            Text("Descripción de la personalidad")
        } footer: {
            Text("Describe como te gustaría que se comporte GPT. Puedes customizar el vocabulario, la expertíz, sus sentimientos y muchas cosas más.")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private extension GPTPersonalityView {
    func saveGPTPersonality() {
        let newPersonality = GPTPersonality(
            id: personality?.id ?? UUID().uuidString,
            name: titleText,
            description: descriptionText
        )
        viewModel.saveGPTPersonality(newPersonality, isEditing: isEditing)
        dismiss()
    }
}

struct GPTPersonalityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GPTPersonalityView(viewModel: GPTPersonalityViewModel())
        }
    }
}
