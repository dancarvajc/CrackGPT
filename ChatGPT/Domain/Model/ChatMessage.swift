//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 09-04-23.
//

import CoreData
import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id: String
    let role: ChatRole
    var content: String
    let created: Date

    init(role: ChatRole, content: String) {
        self.id = UUID().uuidString
        self.role = role
        self.content = content
        self.created = Date.now
    }
}

// MARK: CoreData init

extension ChatMessage {
    init(entity: ChatMessageEntity) {
        self.id = entity.ID
        self.created = entity.created
        self.role = entity.role
        self.content = entity.content
    }
}

extension ChatMessage {
    var isUser: Bool {
        return role == .user
    }

    var roleText: String {
        isUser ? "**Yo:**" : "**CrackGPT:**"
    }

    var separatedMessages: [String] {
        content.separateCodeBlocks()
    }
}
