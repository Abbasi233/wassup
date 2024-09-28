//
//  ChatPageVMTest.swift
//  wassupTests
//
//  Created by Furkan Abbasioğlu on 28.09.2024.
//

import XCTest
@testable import wassup

final class ChatPageVMTest: XCTestCase {
    
    let viewModel = ChatPageVM()

    func testListenChatMessages() async throws {
        var messageList = [ChatMessage] ()
        viewModel.listenChatMessages(chatId: "j1smetAhsZjbxW8hzbjG") { optionalData in
            if let data = optionalData {
                messageList = data
            }
        }
        
        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)

        XCTAssertGreaterThan(messageList.count, 0, "An error occurred when chat messages listening")
    }

}
