//
//  ChatSidebar.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 15-04-23.
//

import CoreData
import Foundation

struct ChatSidebar: Identifiable, Hashable {
    var id: String
    var name: String
    let date: Date

    init(id: String) {
        self.id = id
        self.name = ""
        self.date = Date.now
    }

    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.date = Date.now
    }
}

// MARK: CoreData init

extension ChatSidebar {
    init(entity: ChatSidebarEntity) {
        self.id = entity.ID
        self.date = entity.date
        self.name = entity.title
    }
}
