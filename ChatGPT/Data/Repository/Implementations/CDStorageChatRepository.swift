//
//  CDStorageChatRepository.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import CoreData
import Foundation

final class CDStorageChatRepository: StorageChatRepositoryProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ object: ChatMessage, to sidebar: ChatSidebar) throws {
        guard let sidebarEntity = getChatSidebarEntity(sidebar) else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSCoreDataError, userInfo: [NSLocalizedDescriptionKey: "Sidebar entity not found."])
        }
        let chatSidebarEntity = ChatMessageEntity(context: context)
        chatSidebarEntity.ID = object.id
        chatSidebarEntity.role = object.role
        chatSidebarEntity.content = object.content
        chatSidebarEntity.created = object.created
        sidebarEntity.addToChatmessageEntities(chatSidebarEntity)
        try context.save()
    }

    func fetchAll(from sidebar: ChatSidebar, reversed: Bool) -> [ChatMessage] {
        guard let chatSidebarEntity = getChatSidebarEntity(sidebar) else {
            return []
        }
        let fetchRequest = ChatMessageEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_", ascending: !reversed)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "chatsidebarEntity == %@", chatSidebarEntity)
        let entitites = try? context.fetch(fetchRequest)
        let messages = entitites?.compactMap {
            return ChatMessage(entity: $0)
        }
        return messages ?? []
    }

    func deleteAll() {
        guard let entityName = ChatSidebarEntity.entity().name else { return }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            if let result = try context.execute(deleteRequest) as? NSBatchDeleteResult,
               let arrayResult = result.result as? [NSManagedObjectID]
            {
                let changes: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: arrayResult,
                ]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                try context.save()
            }
        } catch {
            print("--- error when deleting all chats")
        }
    }

    private func getChatSidebarEntity(_ sidebar: ChatSidebar) -> ChatSidebarEntity? {
        let fetchRequest = ChatSidebarEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ == %@", sidebar.id)
        let sidebarEntity = try? context.fetch(fetchRequest).first
        return sidebarEntity
    }
}
