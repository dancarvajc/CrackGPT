//
//  ChatView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 09-04-23.
//

import Combine
import Factory
#if os(iOS)
import SimpleUIList
#endif
import SwiftUI
import SwiftUIIntrospect

struct ChatView: View {
    @AppStorage("gptModel") private var gptModel: String = GPTModel.default.rawValue
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var textfieldIsFocused: Bool
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    @State private var fontSize: CGFloat = 18
    @State private var shouldScrollToBottom: Bool = true
    @State private var chatTask: Task<Void, Never>?
    @State private var gptPersonality: GPTPersonality = .default
    @State private var isOptionsViewHidden: Bool
    @State private var showEmptyChatAlert = false
    @State private var showChatView = false
    @State private var isFirstTime = true
    @Binding private var isAbleToCreateNewChat: Bool
    private let title: String

    init(chatSidebar: ChatSidebar, title: String, isAbleToCreateNewChat: Binding<Bool>) {
        #if os(iOS)
        _viewModel = StateObject(
            wrappedValue: ChatViewModel(chatSidebar: chatSidebar, isListReversed: true))
        #else
        _viewModel = StateObject(
            wrappedValue: ChatViewModel(chatSidebar: chatSidebar, isListReversed: false))
        #endif
        self.title = title
        self._isAbleToCreateNewChat = isAbleToCreateNewChat
        self._isOptionsViewHidden = State(wrappedValue: UserDefaults.standard.bool(forKey: "isOptionsViewHidden"))
    }

    var body: some View {
        content
            .navigationTitle(title)
            .toolbar {
                toolbarView
            }
        #if os(iOS)
            .alert(isPresented: $showEmptyChatAlert) {
                Alert(title: Text("Nope"),
                      message: Text("¡No hay chat el que compartir!"),
                      dismissButton: .default(Text("Ok")))
            }
            .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
            .detectKey(KeyEquivalent("d"), modifiers: .command) {
                chatTask?.cancel()
        }
        #endif
        .task {
            await viewModel.loadHistoryChat()
            #if os(iOS)
            if viewModel.messages.isEmpty {
                if #available(iOS 16, *) {
                    textfieldIsFocused = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        textfieldIsFocused = true
                    }
                }
            }
            #endif
            viewModel.getGPTPersonalities()
            if let firstPersonality = viewModel.gptPersonalities.first {
                gptPersonality = firstPersonality
            }
        }
        .onDisappear {
            isAbleToCreateNewChat = true
            chatTask?.cancel()
        }
    }
}

// MARK: Views

private extension ChatView {
    var content: some View {
        chatView
            .background {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .opacity(viewModel.isLoadingChat ? 1 : 0)
            }
            .overlay {
                emptyView
                    .opacity(viewModel.isLoadingChat || !viewModel.messages.isEmpty ? 0 : 1)
                    .padding(.bottom, 150)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }

    var emptyView: some View {
        HStack(spacing: 10) {
            Text("CrackGPT")
                .font(.title.bold())
            Image(systemName: viewModel.emptyImages)
                .font(.title.bold())
        }.accessibilityHidden(true)
    }

    @ViewBuilder
    var chatView: some View {
        VStack(alignment: .leading, spacing: 0) {
            #if os(macOS)
            chatViewMacOSVersion
            #else
            chatViewiOSVersion
            #endif
            inputTextView
        }
    }

    var exportableChatView: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("CrackGPT")
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            ScrollView {
                VStack {
                    ForEach(viewModel.messages.reversed()) { chat in
                        ChatMessageRow(chat: chat, fontSize: fontSize)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom)
        }.accessibilityHidden(true)
    }

    #if os(macOS)
    var chatViewMacOSVersion: some View {
        List {
            ForEach(viewModel.messages) { chat in
                ChatMessageRow(chat: chat, fontSize: fontSize)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .environmentObject(viewModel)
        .listStyle(.plain)
        .opacity(showChatView ? 1 : 0)
        .animation(.default, value: showChatView)
        .introspect(.list, on: .macOS(.v12, .v13, .v14)) { tableView in
            viewModel.tableView = tableView
        }
        .onChange(of: viewModel.messages.last) { _ in
            DispatchQueue.main.async {
                scrollToBottomIfNecessary()
            }
        }
    }
    #endif

    #if os(iOS)
    var chatViewiOSVersion: some View {
        SimpleUIList(viewModel.messages) { chat in
            ChatMessageRow(chat: chat, fontSize: fontSize)
                .allowsHitTesting(!isLoading)
                .padding(.horizontal)
        }
        .reverseList(true)
        .startAtBottom(true)
        .environmentObject(viewModel)
        .opacity(viewModel.messages.isEmpty ? 0 : 1)
        .animation(.default, value: viewModel.messages.isEmpty)
    }
    #endif

    var inputTextView: some View {
        VStack {
            #if os(iOS)
            if !isOptionsViewHidden {
                miniOptionsView
                    .transition(.move(edge: .bottom).combined(with: .opacity.animation(.default.speed(3))))
            }
            #endif
            HStack(spacing: 0) {
                #if os(iOS)
                chevronButton
                TextEditorView(
                    text: $inputText,
                    placeholder: "Mensaje",
                    minHeight: 30,
                    maxLinesDisplayed: 5,
                    textSize: fontSize
                )
                .foregroundColor(isLoading ? .gray : .white)
                .padding(7)
                .background(Color(.systemBackground).cornerRadius(10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(isLoading ? .gray : .label), lineWidth: 1)
                )
                .disabled(isLoading && !textfieldIsFocused)
                .focused($textfieldIsFocused)
                #else
                NSTextViewUI(text: $inputText,
                             isDisabled: isLoading)
                {
                    textfieldIsFocused = false
                    sendMessage()
                }
                .frame(height: 50)
                .padding(15)
                .background(Color(NSColor.windowBackgroundColor).cornerRadius(10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(isLoading ? .gray : .textColor), lineWidth: 1)
                )
                .disabled(isLoading && !textfieldIsFocused)
                .focused($textfieldIsFocused)
                #endif
                sendButtonView
            }
        }
        .padding()
        .background(Material.ultraThick)
        #if os(iOS)
            .cornerRadius(8, corners: [.topLeft, .topRight])
        #endif
    }

    var chevronButton: some View {
        Button {
            withAnimation(.smooth.speed(1.5)) {
                isOptionsViewHidden.toggle()
            }
        }
        label: {
            Image(systemName: "chevron.down.circle.fill")
                .font(.system(size: 22))
                .rotationEffect(.degrees(isOptionsViewHidden ? 180 : 0))
        }
        .accessibilityLabel("Más opciones")
        .accessibilityHint("Toca dos veces para \(isOptionsViewHidden ? "abrir" : "cerrar") menú de ajustes")
        .frame(width: 35, height: 45, alignment: .leading)
        .contentShape(Rectangle())
    }

    var sendButtonView: some View {
        Button(action: sendButtonAction) {
            Image(systemName: isLoading ? "stop.circle" : viewModel.errorOcurred ? "arrow.clockwise" : "paperplane")
                .font(.system(size: 22))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isLoading ? "Detener respuesta de CrackGPT" : viewModel.errorOcurred ? "Reintentar enviar mensaje" : "Enviar mensaje")
        .frame(width: 35, height: 45, alignment: .trailing)
        .contentShape(Rectangle())
    }

    var shareButtonView: some View {
        Button {
            #if os(iOS)
            FeedbackGenerator.play(.heavy)
            withAnimation {
                isOptionsViewHidden = true
            }
            guard !viewModel.messages.isEmpty else {
                showEmptyChatAlert = true
                return
            }
            let hostView = UIHostingController(rootView: ChatSharingView {
                exportableChatView
                    .onAppear {
                        DispatchQueue.main.async {
                            shareChat()
                        }
                    }
            })
            hostView.overrideUserInterfaceStyle = .dark
            hostView.modalPresentationStyle = .overFullScreen
            hostView.view.backgroundColor = UIColor.clear
            hostView.modalTransitionStyle = .crossDissolve
            UIWindow.topMostViewController?.present(hostView, animated: true)
            #else
            // TODO: DO MacOS share functionality
            #endif
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Compartir chat en formato PDF")
        .padding([.leading, .vertical])
        .contentShape(Rectangle())
    }

    var toolbarView: some ToolbarContent {
        ToolbarItemGroup {
            #if os(iOS)
            HStack(spacing: 15) {
                if viewModel.isSpeaking {
                    Button(action: viewModel.stopSpeakingMessage) {
                        Image(systemName: "speaker.slash")
                    }.buttonStyle(.plain)
                }
                shareButtonView
            }
            #else
            gptModelToolbarView
            gptPersonalitySelectorView
            speakContentToolbarView
            fontSizeToolbarView
            #endif
        }
    }

    var miniOptionsView: some View {
        HStack(alignment: .center) {
            Menu {
                gptModelToolbarView
            } label: {
                VStack {
                    Text("Modelo")
                        .font(.title2.bold())
                    Text(GPTModel(rawValue: gptModel).name)
                        .font(.body).italic()
                }
            }
            .menuStyle(MyCustomMenuStyle())
            #if os(iOS)
                .foregroundColor(Color(.label))
            #else
                .foregroundColor(Color(.textColor))
            #endif

            Menu {
                gptPersonalitySelectorView
            } label: {
                VStack {
                    Text("Personalidad")
                        .font(.title2.bold())
                    Text(gptPersonality.name)
                        .font(.body)
                        .italic()
                }
            }.menuStyle(MyCustomMenuStyle())
        }.padding(.bottom)
    }

    var gptPersonalitySelectorView: some View {
        #if os(iOS)
        Section("Personalidad de GPT") {
            ForEach(viewModel.gptPersonalities) { personality in
                Button {
                    gptPersonality = personality
                    viewModel.setGPTPersonality(personality)
                } label: {
                    if gptPersonality == personality {
                        Label(personality.name, systemImage: "checkmark")
                    } else {
                        Text(personality.name)
                    }
                }
            }
        }
        #else
        Menu {
            Picker("Personalidad de GPT", selection: $gptPersonality) {
                ForEach(viewModel.gptPersonalities, id: \.self) { personality in
                    Text(personality.name)
                }
            }
            .pickerStyle(.inline)
        } label: {
            Text(gptPersonality.name)
        }
        .onChange(of: gptPersonality) { personality in
            viewModel.setGPTPersonality(personality)
        }
        #endif
    }

    var fontSizeToolbarView: some View {
        Slider(value: $fontSize,
               in: 8 ... 50,
               minimumValueLabel:
               Text("A").font(.system(size: 8)),
               maximumValueLabel:
               Text("A").font(.system(size: 16)))
        {
            Text("Font Size (\(Int(fontSize)))")
        }
        .frame(width: 150)
    }

    var speakContentToolbarView: some View {
        #if os(iOS)
        Section("Leer con voz") {
            Button(action: viewModel.speakLastResponse) {
                Label("Leer última respuesta", systemImage: "speaker.wave.2.fill")
                Image(systemName: "speaker.fill")
            }
            Button(action: viewModel.stopSpeakingMessage) {
                Label("Parar de leer", systemImage: "stop.fill")
            }
        }
        #else
        HStack {
            Button(action: viewModel.speakLastResponse) {
                Label("Leer última respuesta", systemImage: "speaker.wave.2.fill")
            }
            Button(action: viewModel.stopSpeakingMessage) {
                Label("Parar de leer", systemImage: "stop.fill")
            }
        }
        #endif
    }

    var gptModelToolbarView: some View {
        #if os(iOS)
        Section("Modelo de GPT") {
            ForEach(GPTModel.allCases) { model in
                Button {
                    gptModel = model.rawValue
                } label: {
                    if gptModel == model.rawValue {
                        Label(model.name, systemImage: "checkmark")
                    } else {
                        Text(model.name)
                    }
                }
            }
        }
        #else
        Menu {
            Picker("Modelo de GPT", selection: $gptModel) {
                ForEach(GPTModel.allCases) { model in
                    Text(model.rawValue)
                }
            }
            .pickerStyle(.inline)
        } label: {
            Text(gptModel)
        }
        #endif
    }
}

private extension ChatView {
    func sendButtonAction() {
        if isLoading {
            chatTask?.cancel()
        } else if viewModel.errorOcurred {
            retrySendMessage()
        } else {
            sendMessage()
        }
    }

    func retrySendMessage() {
        chatTask = Task {
            isLoading = true
            shouldScrollToBottom = true
            await viewModel.retrySendMessage()
            isLoading = false
        }
    }

    func sendMessage() {
        guard inputText.isEmpty == false else { return }
        chatTask = Task {
            isLoading = true
            shouldScrollToBottom = true
            textfieldIsFocused = false
            await viewModel.sendMessage(content: inputText)
            inputText = ""
            isLoading = false
            #if os(macOS)
            try? await Task.sleep(nanoseconds: 1)
            textfieldIsFocused = true
            #endif
        }
    }

    #if os(macOS)
    func scrollToBottomIfNecessary() {
        guard shouldScrollToBottom, !viewModel.isLoadingChat, !viewModel.messages.isEmpty else { return }
        shouldScrollToBottom = false

        guard let tableView = viewModel.tableView else { return }
        let lastRow = tableView.numberOfRows - 1
        guard let clipView = tableView.enclosingScrollView?.contentView else { return }
        let rowRect = tableView.rect(ofRow: lastRow)
        let newScrollOrigin = NSPoint(x: 0, y: rowRect.maxY - clipView.bounds.height)
        if isFirstTime {
            clipView.scroll(newScrollOrigin)
            isFirstTime = false
            showChatView = true
        } else {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                clipView.animator().setBoundsOrigin(newScrollOrigin)
            }
        }
    }
    #endif

    #if os(iOS)
    func shareChat() {
        let url: URL = .init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(viewModel.chatTitle).appendingPathExtension("pdf")
        let pdfData = exportableChatView.exportToPDF()
        do {
            let topMostViewController = UIWindow.topMostViewController
            try pdfData.write(to: url)
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = topMostViewController?.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                activityVC.popoverPresentationController?.permittedArrowDirections = .down
            }
            activityVC.overrideUserInterfaceStyle = .dark
            activityVC.completionWithItemsHandler = { _, _, _, _ in
                try? FileManager.default.removeItem(at: url)
                UIApplication.shared.activeWindow?.rootViewController?.dismiss(animated: true)
            }
            topMostViewController?.present(activityVC, animated: true)

        } catch {
            let alertSetup = AlertHelperSetup(
                type: .informative,
                title: "¡Ups! Algo salió mal",
                message: "Hubo un error al compartir el chat. Inténtalo nuevamente :)",
                informativeAction: {
                    UIWindow.topMostViewController?.dismiss(animated: true)
                }
            )
            AlertHelper.shared.showAlert(setup: alertSetup)
        }
    }
    #endif
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let _ = Container.shared.coreDataStack.onPreview { CoreDataStack(forPreview: true)
            }
            ChatView(chatSidebar: Container.shared.storageSidebar().fetchAll()[1], title: "test", isAbleToCreateNewChat: .constant(false))
                .preferredColorScheme(.dark)
        }
    }
}
