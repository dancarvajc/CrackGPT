//
//  MainView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 14-04-23.
//

import SwiftUI
import SwiftUIIntrospect

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @FocusState private var focused: Bool
    @State private var currentChatSelected: ChatSidebar.ID?
    @State private var isAbleToCreateNewChat = true
    @State private var showSettingsView = false
    #if os(iOS)
    @State private var canTriggerHaptic: Bool = true
    @State private var scrollTranslation: CGFloat = 0
    @AppStorage("startAppWithNewChat") private var startAppWithNewChat: Bool = false
    @AppStorage("GPTGrettingsEnabled") private var gptGrettingsEnabled: Bool = true
    #else
    @State private var startEditingChatTitle: Bool = false
    @AppStorage("startAppWithNewChat") private var startAppWithNewChat: Bool = true
    #endif

    var body: some View {
        content
        #if os(iOS)
        .sheet(isPresented: $showSettingsView) {
            SettingsView(onDeleteChats: viewModel.getSidebarList)
        }
        #endif
        .onAppear {
            viewModel.getSidebarList()
            if startAppWithNewChat {
                createNewChat()
            }
        }
    }
}

// MARK: Views

private extension MainView {
    var content: some View {
        NavigationView {
            listView
                .frame(minWidth: 240)
                .toolbar {
                    toolbarView
                }
                .navigationTitle("CrackGPT")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .overlay {
                    if viewModel.sidebarList.isEmpty {
                        emptyView
                            .transition(.opacity.animation(.default))
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    bottomView
                }
                .task {
                    guard gptGrettingsEnabled else { return }
                    await viewModel.getGreetingsFromChatGPT()
                }
            #endif
            #if os(macOS)
            .detectKey(.delete) {
                if let currentChatSelected {
                    viewModel.deleteChatList(sidebarChat: ChatSidebar(id: currentChatSelected))
                }
            }
            .detectKey(.return) {
                startEditingChatTitle = true
            }
            .detectKey(KeyEquivalent("r"), modifiers: .command, action: createNewChat)
            .background {
                NavigationLink(isActive: $showSettingsView) {
                    SettingsView(onDeleteChats: viewModel.getSidebarList)
                } label: {
                    EmptyView()
                }
                .opacity(0)
            }
            #endif
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        .introspect(.navigationView(style: .stack), on: .iOS(.v15, .v16, .v17)) { navbar in
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithDefaultBackground()
            navbar.navigationBar.compactAppearance = coloredAppearance
            navbar.navigationBar.standardAppearance = coloredAppearance
            navbar.navigationBar.scrollEdgeAppearance = coloredAppearance
            navbar.navigationBar.compactScrollEdgeAppearance = coloredAppearance
        }
        #endif
    }

    var listView: some View {
        List($viewModel.sidebarList) { $sidebar in
            NavigationLink(tag: sidebar.id, selection: $currentChatSelected) {
                ChatView(chatSidebar: sidebar,
                         title: sidebar.name,
                         isAbleToCreateNewChat: $isAbleToCreateNewChat)
            } label: {
                #if os(iOS)
                SidebarViewiOS(chatSidebar: $sidebar, viewModel: viewModel)
                #else
                SidebarViewMacOS(
                    chatSidebar: $sidebar,
                    viewModel: viewModel,
                    canEditChatTitle: sidebar.id == currentChatSelected,
                    isEditing: $startEditingChatTitle
                )
                #endif
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        .didScroll { scrollView in
            scrollTranslation = scrollView.translation
            if !scrollView.isDragging {
                canTriggerHaptic = true
            }
            if scrollView.translation > 90, canTriggerHaptic {
                canTriggerHaptic = false
                FeedbackGenerator.play(.rigid)
            }
            if scrollView.translation > 90, scrollView.isDragging == false, isAbleToCreateNewChat {
                isAbleToCreateNewChat = false
                canTriggerHaptic = true
                createNewChat()
            }
        }
        #else
        .listStyle(.sidebar)
        #endif
    }

    #if os(iOS)
    var emptyView: some View {
        VStack {
            Image(systemName: "pencil.and.outline")
                .font(.largeTitle)
                .padding(.bottom)
            Text(UIAccessibility.isVoiceOverRunning ? "Iniciar una nueva conversación" : "¡Desliza hacia abajo para iniciar una nueva conversación!")
                .italic()
                .multilineTextAlignment(.center)
        }
        .accessibilityElement()
        .accessibilityLabel("Iniciar una nueva conversación")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            FeedbackGenerator.notify(.success)
            createNewChat()
        }
        .offset(y: scrollTranslation)
        .allowsHitTesting(false)
    }
    #endif

    var toolbarView: some ToolbarContent {
        ToolbarItemGroup {
            #if os(macOS)
            Button(action: toggleSidebar, label: {
                Image(systemName: "sidebar.left")
            })
            Button(action: createNewChat, label: {
                Image(systemName: "plus")
            })
            Button(action: {
                showSettingsView = true
            }, label: {
                Image(systemName: "gearshape")
            })
            #endif
        }
    }

    #if os(iOS)
    var bottomView: some View {
        HStack(spacing: 0) {
            Button {
                FeedbackGenerator.notify(.success)
                createNewChat()
            }
            label: {
                Image(systemName: "plus")
            }
            .accessibilityLabel("Abrir nuevo chat")
            .padding()
            .contentShape(Rectangle())
            Spacer()
            Text(viewModel.chatGPTMessage)
                .font(.footnote)
                .italic()
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .animation(.default, value: viewModel.chatGPTMessage.isEmpty)
                .opacity(gptGrettingsEnabled ? 1 : 0)
            Spacer()
            Button {
                showSettingsView = true
            }
            label: {
                Image(systemName: "gear")
            }
            .accessibilityLabel("Abrir pantalla de ajustes")
            .padding()
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(Material.bar)
    }
    #endif
}

private extension MainView {
    #if os(macOS)
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif

    func createNewChat() {
        let chatCreatedId = viewModel.createNewChatList()
        DispatchQueue.main.async {
            currentChatSelected = chatCreatedId
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
