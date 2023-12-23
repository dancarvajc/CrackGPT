//
//  StorageChatRepositoryProtocol.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import Foundation

protocol StorageChatRepositoryProtocol {
    func save(_ object: ChatMessage, to sidebar: ChatSidebar) throws
    func fetchAll(from sidebar: ChatSidebar, reversed: Bool) -> [ChatMessage]
    func deleteAll()
}
