//
//  GPTPersonality2.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 20-08-23.
//

import CoreData
import Foundation

struct GPTPersonality: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var description: String
    var createdAt: Date

    init(id: String? = UUID().uuidString, name: String, description: String) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.description = description
        self.createdAt = Date.now
    }
}

// MARK: CoreData init

extension GPTPersonality {
    init(entity: GPTPersonalityEntity) {
        self.id = entity.ID
        self.name = entity.name
        self.description = entity.personality
        self.createdAt = entity.date
    }
}

extension GPTPersonality {
    static let `default` = GPTPersonality(
        name: "Muy útil (por defecto)",
        description: "Eres un asistente muy útil."
    )
}
