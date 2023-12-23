//
//  StorageGPTPersonalityProtocol.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import Foundation

protocol StorageGPTPersonalityProtocol {
    func save(_ object: GPTPersonality) throws
    func update(_ object: GPTPersonality) throws
    func delete(_ object: GPTPersonality) throws
    func fetchAll() -> [GPTPersonality]
}
