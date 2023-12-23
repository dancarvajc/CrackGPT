//
//  ChatGPTRepositoryMock.swift
//  ChatGPTTests
//
//  Created by Daniel Carvajal on 09-12-23.
//

@testable import ChatGPT
import Foundation

class ChatGPTRepositoryMock: ChatGPTRepositoryProtocol {
    var lastGPTReply: String?
    var historyList: [ChatMessage] = []
    var personality: GPTPersonality?
    var shouldThrowError = false

    func getChatStream(message _: String) async -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            if shouldThrowError {
                continuation.finish(throwing: URLError(.badURL))
            } else {
                continuation.yield("Simulated reply 1")
                continuation.finish()
            }
        }
    }

    func retryGetChatStream() async -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield("Retry simulated reply 1")
            continuation.finish()
        }
    }

    func setLastGPTReply(content: String) {
        lastGPTReply = content
    }

    func replaceHistoryList(with history: [ChatMessage]) {
        historyList = history
    }

    func setGPTPersonality(with personality: GPTPersonality) {
        self.personality = personality
    }
}
