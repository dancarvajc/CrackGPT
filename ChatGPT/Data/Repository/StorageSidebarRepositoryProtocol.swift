//
//  StorageSidebarRepositoryProtocol.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import Foundation

protocol StorageSidebarRepositoryProtocol {
    func save(_ object: ChatSidebar) throws
    func update(_ object: ChatSidebar) throws
    func delete(_ object: ChatSidebar) throws
    func fetchAll() -> [ChatSidebar]
}
