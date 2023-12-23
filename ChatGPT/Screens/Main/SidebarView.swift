//
//  SidebarView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 15-04-23.
//

import SwiftUI

struct SidebarViewMacOS: View {
    @Binding var chatSidebar: ChatSidebar
    let viewModel: MainViewModel
    let canEditChatTitle: Bool
    @Binding var isEditing: Bool
    @FocusState private var focused: Bool

    var body: some View {
        if canEditChatTitle, isEditing {
            TextField(chatSidebar.name, text: $chatSidebar.name)
                .focused($focused)
                .onChange(of: focused) { isFocused in
                    if isFocused == false {
                        isEditing = false
                        viewModel.saveChatListName(sidebarChat: chatSidebar)
                    }
                }
                .onAppear {
                    focused = true
                }
                .onSubmit {
                    isEditing = false
                    viewModel.saveChatListName(sidebarChat: chatSidebar)
                }
        } else {
            Text(chatSidebar.name)
        }
    }
}

#if os(iOS)
struct SidebarViewiOS: View {
    @Binding var chatSidebar: ChatSidebar
    let viewModel: MainViewModel
    var body: some View {
        Text(chatSidebar.name)
            .contextMenu {
                Button {
                    let alertSetup = AlertHelperSetup(
                        type: .textfield,
                        title: "Editar título",
                        message: "Escribe el nuevo título",
                        textfieldCurrentText: chatSidebar.name,
                        textfieldPlaceholder: "Aquí...",
                        textfieldAcceptAction: { text in
                            chatSidebar.name = text
                            viewModel.saveChatListName(sidebarChat: chatSidebar)
                        }
                    )
                    AlertHelper.shared.showAlert(setup: alertSetup)
                } label: {
                    Label("Cambiar título", systemImage: "pencil")
                }
                Button(role: .destructive) {
                    let alertSetup = AlertHelperSetup(
                        type: .destructive,
                        title: "¿Deseas eliminar este chat?",
                        message: chatSidebar.name,
                        destructiveAction: {
                            viewModel.deleteChatList(sidebarChat: chatSidebar)
                        }
                    )
                    AlertHelper.shared.showAlert(setup: alertSetup)
                } label: {
                    Label("Borrar chat", systemImage: "trash")
                }
            }
    }
}
#endif
