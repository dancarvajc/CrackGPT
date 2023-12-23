//
//  CDStorageSidebarRepository.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import CoreData
import Foundation

final class CDStorageSidebarRepository: StorageSidebarRepositoryProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ object: ChatSidebar) throws {
        let chatSidebarEntity = ChatSidebarEntity(context: context)
        chatSidebarEntity.ID = object.id
        chatSidebarEntity.date = object.date
        chatSidebarEntity.title = object.name
        try context.save()
    }

    func update(_ object: ChatSidebar) throws {
        let fetchRequest = ChatSidebarEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ == %@", object.id)
        if let entityToEdit = try context.fetch(fetchRequest).first {
            entityToEdit.title = object.name
            entityToEdit.date = object.date
            try context.save()
        }
    }

    func delete(_ object: ChatSidebar) throws {
        let fetchRequest = ChatSidebarEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ == %@", object.id)
        if let result = try context.fetch(fetchRequest).first {
            context.delete(result)
            try context.save()
        }
    }

    func fetchAll() -> [ChatSidebar] {
        let fetchRequest = ChatSidebarEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date_", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let objects = try? context.fetch(fetchRequest) {
            return objects.compactMap { ChatSidebar(entity: $0) }
        }
        return []
    }
}
