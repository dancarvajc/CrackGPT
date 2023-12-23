//
//  File.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 15-07-23.
//

import Foundation
import OpenAI

extension [ChatMessage] {
    func mapToOpenAIModel() -> [Chat] {
        let mapped = map { chat in
            let role = Chat.Role(rawValue: chat.role.rawValue) ?? .user
            return Chat(role: role, content: chat.content)
        }
        return mapped
    }
}

extension [Chat] {
    var content: String { reduce("") { $0 + ($1.content ?? "") } }
}
