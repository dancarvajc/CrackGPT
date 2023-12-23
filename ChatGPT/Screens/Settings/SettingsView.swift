//
//  SettingsView.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-08-23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var gptPersonalityViewModel = GPTPersonalityViewModel()
    @AppStorage("startAppWithNewChat") private var toggleIsOn: Bool = false
    @AppStorage("GPTGrettingsEnabled") private var gptGrettingsEnabled: Bool = true
    @AppStorage("gptModel") private var defaultGPT: String = GPTModel.default.rawValue
    @AppStorage("gptGrettings") private var defaultGPTGrettings: String = GPTGrettings.default.rawValue
    @AppStorage("isOptionsViewHidden") private var isOptionsViewHidden: Bool = false
    @State private var showDeleteAllChatAlert = false
    @State private var showDeleteTokenAlert = false
    @State private var showSavedTokenAlert = false
    @State private var showNewPersonalityView = false
    @State private var showSavedCustomGPTAlert = false
    @State private var showErrorCustomGPTAlert = false
    @State private var gptToken: String = ""
    @State private var isTokenSaved: Bool = false
    @State private var personalityToEdit: GPTPersonality?
    @State private var customGPTModel: String
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Desconocida"
    }

    private let onDeleteChats: () -> Void

    init(onDeleteChats: @escaping () -> Void = {}) {
        self.onDeleteChats = onDeleteChats
        self._customGPTModel = State(wrappedValue: UserDefaults.standard.string(forKey: "customGPTModel") ?? "")
    }

    var body: some View {
        content
            .task {
                gptPersonalityViewModel.loadGPTPersonalities()
                isTokenSaved = viewModel.checkForTokenSaved()
                if isTokenSaved {
                    gptToken = viewModel.getToken()
                }
            }
        #if os(macOS)
            .sheet(item: $personalityToEdit) { personality in
                GPTPersonalityView(personality, viewModel: gptPersonalityViewModel)
                    .padding()
            }
        #endif
        #if os(macOS)
            .sheet(isPresented: $showNewPersonalityView) {
                GPTPersonalityView(viewModel: gptPersonalityViewModel)
                    .padding()
        }
        #endif
        .alert("Borrar Token", isPresented: $showDeleteTokenAlert) {
            Button("No", role: .cancel) {}
            Button("Sí", role: .destructive, action: removeToken)
        } message: {
            Text("¿Deseas eliminar tu token? \n No podrás utilizar ChatGPT.")
        }
        .alert("Borrar chats", isPresented: $showDeleteAllChatAlert) {
            Button("No", role: .cancel) {}
            Button("Sí", role: .destructive, action: deleteAllChats)
        } message: {
            Text("¿Deseas borrar todos los chats?")
        }
        .alert("Buenardo", isPresented: $showSavedTokenAlert) {
            Button("Ok") {}
        } message: {
            Text("¡Token guardado con éxito!")
        }
        .alert("¡Configuración guardada!", isPresented: $showSavedCustomGPTAlert) {
            Button("Ok") {}
        } message: {
            let alertMessage = customGPTModel.isEmpty ? "El modelo custom ha sido eliminado." : "Tu modelo custom ha sido guardado con éxito."
            Text(alertMessage)
        }
        .alert("Nope", isPresented: $showErrorCustomGPTAlert) {
            Button("Ok") {}
        } message: {
            Text("Debes ingresar un modelo diferente a los predeterminados.")
        }
    }
}

private extension SettingsView {
    var content: some View {
        #if os(iOS)
        NavigationView {
            Form {
                gptModelSection
                personalitySection
                generalSection
                tokenSection
                currentVersionView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Ajustes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .buttonStyle(.plain)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }.buttonStyle(.plain)
                }
            }
        }
        #else
        ScrollView {
            VStack(alignment: .leading) {
                VStack(spacing: 20) {
                    GroupBox {
                        generalSection
                    }
                    GroupBox {
                        gptModelSection
                    }
                    GroupBox {
                        personalitySection
                    }
                    .frame(minHeight: 200)
                    GroupBox {
                        tokenSection
                    }
                    GroupBox {
                        currentVersionView
                    }
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Ajustes")
        #endif
    }

    var tokenSection: some View {
        Section(header: Text("Token OpenAI")) {
            TextField("Ingresa tu token", text: $gptToken)
            Button("Guardar token") {
                saveToken()
            }.disabled(gptToken.isEmpty)
            if isTokenSaved {
                Button("Remover token") {
                    showDeleteTokenAlert = true
                }.foregroundColor(.red)
            }
        }
    }

    var generalSection: some View {
        Section(header: Text("General")) {
            Toggle("Empezar a chatear al abrir la app", isOn: $toggleIsOn)
                .lineLimit(2)
            #if os(iOS)
            Toggle("Ocultar menú de opciones en el chat", isOn: $isOptionsViewHidden)
                .lineLimit(2)
            greetingsGPTModel
            #endif
            Button("Borrar todos los chats") {
                showDeleteAllChatAlert = true
            }
            .foregroundColor(.red)
        }
    }

    var personalitySection: some View {
        Section(header: Text("Personalidades de GPT")) {
            List {
                ForEach(gptPersonalityViewModel.personalities) { personality in
                    #if os(iOS)
                    NavigationLink(personality.name) {
                        GPTPersonalityView(personality, viewModel: gptPersonalityViewModel)
                    }
                    #else
                    VStack(alignment: .leading) {
                        Divider()
                        Text(personality.name)
                        Divider()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        personalityToEdit = personality
                    }
                    #endif
                }
                .onDelete { offsets in
                    gptPersonalityViewModel.deletePersonality(offsets)
                }
                .onMove { from, to in
                    gptPersonalityViewModel.movePersonalityOrder(fromOffsets: from, toOffset: to)
                }
            }
            Button("Añadir nueva personalidad") {
                #if os(iOS)

                // MARK: Fix iOS 17 bug not releasing the viewModel

                let hostView = UIHostingController(rootView: NavigationView { GPTPersonalityView(viewModel: gptPersonalityViewModel) })

                UIWindow.topMostViewController?.present(hostView, animated: true)
                #else
                showNewPersonalityView = true
                #endif
            }
        }
    }

    var gptModelSection: some View {
        Section {
            Picker("", selection: $defaultGPT) {
                ForEach(GPTModel.allCases, id: \.id) { model in
                    Text(model.name)
                }
            }
            .pickerStyle(.segmented)
            TextField("Modelo custom", text: $customGPTModel)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
                .autocorrectionDisabled(true)
            Button("Guardar", action: saveCustomGPTModel)
                .accessibilityHint("Guardar el modelo custom ingresado")
        } header: {
            Text("Modelo de GPT")
        } footer: {
            Text("Añade un modelo custom de GPT. Esto es útil para probar versiones nuevas tan pronto como estén disponibles. [Modelos disponibles](https://platform.openai.com/docs/models).")
        }
    }

    var greetingsGPTModel: some View {
        VStack(spacing: 10) {
            Toggle("Mostrar saludos de GPT en Home", isOn: $gptGrettingsEnabled)
                .lineLimit(2)
            if gptGrettingsEnabled {
                Picker("", selection: $defaultGPTGrettings) {
                    ForEach(GPTGrettings.allCases, id: \.id) { model in
                        Text(model.name)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    var currentVersionView: some View {
        Text("**CrackGPT v\(appVersion)** \n _Hecha con cariño por_ **DMCC**")
            .font(.caption)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
    }
}

private extension SettingsView {
    func deleteAllChats() {
        viewModel.deleteAllChats()
        onDeleteChats()
        dismiss()
    }

    func saveToken() {
        viewModel.saveToken(gptToken)
        showSavedTokenAlert = true
    }

    func removeToken() {
        viewModel.removeToken()
        isTokenSaved = false
        gptToken = ""
    }

    private func saveCustomGPTModel() {
        guard customGPTModel != .gpt4, customGPTModel != .gpt3_5Turbo, customGPTModel != .gpt4_1106_preview else {
            showErrorCustomGPTAlert = true
            return
        }
        UserDefaults.standard.set(customGPTModel, forKey: "customGPTModel")
        defaultGPT = customGPTModel.isEmpty ? .gpt4_1106_preview : customGPTModel
        showSavedCustomGPTAlert = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
