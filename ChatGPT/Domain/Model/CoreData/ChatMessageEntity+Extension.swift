//
//  ChatMessageEntity+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-04-23.
//

import Foundation

extension ChatMessageEntity {
    var ID: String {
        get {
            return id_ ?? ""
        }
        set {
            id_ = newValue
        }
    }

    var content: String {
        get {
            return content_ ?? ""
        }
        set {
            content_ = newValue
        }
    }

    var role: ChatRole {
        get {
            return ChatRole(rawValue: role_ ?? "") ?? .user
        }

        set {
            role_ = newValue.rawValue
        }
    }

    var created: Date {
        get {
            return created_ ?? Date.now
        }
        set {
            created_ = newValue
        }
    }
}
