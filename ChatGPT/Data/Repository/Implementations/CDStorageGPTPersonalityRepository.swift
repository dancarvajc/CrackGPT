//
//  CDStorageGPTPersonalityRepository.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import CoreData
import Foundation

final class CDStorageGPTPersonalityRepository: StorageGPTPersonalityProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ object: GPTPersonality) throws {
        let gptPersonalityEntity = GPTPersonalityEntity(context: context)
        gptPersonalityEntity.ID = object.id
        gptPersonalityEntity.personality = object.description
        gptPersonalityEntity.name = object.name
        gptPersonalityEntity.date = object.createdAt
        try context.save()
    }

    func update(_ object: GPTPersonality) throws {
        let fetchRequest = GPTPersonalityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ == %@", object.id)
        if let entityToEdit = try context.fetch(fetchRequest).first {
            entityToEdit.personality = object.description
            entityToEdit.name = object.name
            entityToEdit.date = object.createdAt
            try context.save()
        }
    }

    func delete(_ object: GPTPersonality) throws {
        let fetchRequest = GPTPersonalityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_ == %@", object.id)
        if let result = try context.fetch(fetchRequest).first {
            context.delete(result)
            try context.save()
        }
    }

    func fetchAll() -> [GPTPersonality] {
        let fetchRequest = GPTPersonalityEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date_", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let objects = try? context.fetch(fetchRequest) {
            return objects.compactMap { GPTPersonality(entity: $0) }
        }
        return []
    }
}
