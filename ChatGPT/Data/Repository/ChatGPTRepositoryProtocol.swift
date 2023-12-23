//
//  ChatGPTRepositoryProtocol.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import Foundation

protocol ChatGPTRepositoryProtocol {
    func getChatStream(message: String) async -> AsyncThrowingStream<String, Error>
    func retryGetChatStream() async -> AsyncThrowingStream<String, Error>
    func setLastGPTReply(content: String)
    func replaceHistoryList(with history: [ChatMessage])
    func setGPTPersonality(with personality: GPTPersonality)
}
