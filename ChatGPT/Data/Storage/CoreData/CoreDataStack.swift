//
//  CoreDataStack.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 02-09-23.
//

import CoreData

final class CoreDataStack {
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext

    init(forPreview: Bool = false) {
        self.persistentContainer = NSPersistentContainer(name: "ChatDataModel")
        if forPreview {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Function 'loadPersistentStores' threw an error: \(String(describing: error?.localizedDescription))")
            }
        }

        self.mainContext = persistentContainer.viewContext
        self.backgroundContext = persistentContainer.newBackgroundContext()
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

        if forPreview {
            addMockData()
        } else {
            preloadDataIfNeeded()
        }
    }
}

private extension CoreDataStack {
    func addMockData() {
        createChatSidebar()
        createGPTPersonalities()
        try? mainContext.save()
    }

    func createChatSidebar() {
        let sidebars = ["Chat 1", "Chat 2", "Chat 3"]
        sidebars.forEach { sidebar in
            let entity = ChatSidebarEntity(context: mainContext)
            entity.ID = UUID().uuidString
            entity.title = sidebar
            entity.date = Date.now
            if sidebar == "Chat 2" {
                createChatMessages(relationEntity: entity)
            }
        }
    }

    func createGPTPersonalities() {
        let personalities: [(title: String, description: String)] = [
            ("Experto programador", "Eres un asistente experto en programación. Manejas muy bien los lenguajes de programación. Debes responder los bloques de código sin especificar el lenguaje."),
            ("Chileno", "Eres un asistente chileno, hablas como chileno y eres divertido."),
            ("Muy útil", "Eres un asistente muy útil."),
        ]
        personalities.forEach { gptPersonality in
            let entity = GPTPersonalityEntity(context: mainContext)
            entity.id_ = UUID().uuidString
            entity.name_ = gptPersonality.title
            entity.personality_ = gptPersonality.description
            entity.date = Date.now
        }
    }

    func preloadDataIfNeeded() {
        let hasPersonalitiesAdded = UserDefaults.standard.bool(forKey: "hasPersonalitiesAdded")
        guard !hasPersonalitiesAdded else { return }
        createGPTPersonalities()
        try? mainContext.save()
        UserDefaults.standard.set(true, forKey: "hasPersonalitiesAdded")
    }

    func createChatMessages(relationEntity: ChatSidebarEntity) {
        let code = """
        Si mira, así lo puedes hacer:

        ```swift
        import SwiftUI

        struct ContentView: View {
            var body: some View {
                VStack {
                    Image(systemName: "globe1")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
            }
        }
        ```

        Igual se puede hacer así, queda a gusto del consumidor:

        ```swift
        import SwiftUI

        struct ContentView: View {
            var body: some View {
                VStack {
                    Image(systemName: "globe2")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
            }
        }
        ```
                ```swift
                import SwiftUI

                struct ContentView: View {
                    var body: some View {
                        VStack {
                            Image(systemName: "globe3")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Hello, world!")
                        }
                    }
                }
                ```
                ```swift
                import SwiftUI

                struct ContentView: View {
                    var body: some View {
                        VStack {
                            Image(systemName: "globe4")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Hello, world!")
                        }
                    }
                }
                ```
                ```swift
                import SwiftUI

                struct ContentView: View {
                    var body: some View {
                        VStack {
                            Image(systemName: "globe5")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Hello, world!")
                        }
                    }
                }
                ```
                ```swift
                import SwiftUI

                struct ContentView: View {
                    var body: some View {
                        VStack {
                            Image(systemName: "globe6")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Hello, world!")
                        }
                    }
                }
                ```
        """
        let chat = [
            ChatMessage(role: .user, content: "Hola, dime un chiste de nutrias."),
            ChatMessage(role: .user, content: "En 1905, cuando era un joven físico desconocido, empleado en la Oficina de Patentes de Berna, publicó su teoría de la relatividad especial. En ella incorporó, en un marco teórico simple fundamentado en postulados físicos sencillos, conceptos y fenómenos estudiados antes por Henri Poincaré y Hendrik Lorentz. Como una consecuencia lógica de esta teoría, dedujo la ecuación de la física más conocida a nivel popular: la equivalencia masa-energía, E=mc². Ese año, publicóassas otros trabajos que sentarían algunas de las bases de la física estadística y de la mecánica cuántica."),
            ChatMessage(role: .assistant, content: "No me sé ningún chiste de nutrias."),
            ChatMessage(role: .user, content: "En 1905, cuando era un joven físico desconocido, empleado en la Oficina de Patentes de Berna, publicó su teoría de la relsdatividad especial. En ella incorporó, en un marco teórico simple fundamentado en postulados físicos sencillos, conceptos y fenómenos estudiados antes por Henri Poincaré y Hendrik Lorentz. Como una consecuencia lógica de esta teoría, dedujo la ecuación de la física más conocida a nivel popular: la equivalencia masa-energía, E=mc². Ese año, publicó otros trabajos que sentarían algunas de las bases de la física estadística y de la mecánica cuántica."),
            ChatMessage(role: .assistant, content: "No masdase sé ningún chiste de nutrias."),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .assistant, content: code),
            ChatMessage(role: .user, content: "Bien gracias. ¿En qué te puedo ayudar hoy?"),
        ]

        chat.forEach { message in
            let entity = ChatMessageEntity(context: mainContext)
            entity.content = message.content
            entity.role = message.role
            entity.created = Date.now
            entity.ID = message.id
            entity.chatsidebarEntity = relationEntity
        }
    }
}
