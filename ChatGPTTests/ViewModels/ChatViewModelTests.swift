//
//  ChatViewModelTests.swift
//  ChatGPTTests
//
//  Created by Daniel Carvajal on 09-12-23.
//

@testable import ChatGPT
import Factory
import XCTest

@MainActor
final class ChatViewModelTests: XCTestCase {
    var sut: ChatViewModel!

    override func setUp() {
        super.setUp()
        Container.shared.coreDataStack.register { CoreDataStack(forPreview: true) }
        Container.shared.chatGPTRepository.register { ChatGPTRepositoryMock() }
        sut = ChatViewModel(chatSidebar: ChatSidebar(name: "chat1"), isListReversed: false)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSendMessage() async {
        let message = "a message"
        await sut.sendMessage(content: message)
        XCTAssertEqual(sut.messages.count, 2)
    }
}
