//
//  ChatListVMTest.swift
//  wassupTests
//
//  Created by Furkan Abbasioğlu on 28.09.2024.
//

import XCTest
@testable import wassup

final class ChatListVMTest: XCTestCase {
    
    let viewModel = ChatListVM()

    override func setUpWithError() throws {
        User.instance.setUser(
            uid: "ecegHXXv9FONr9nn8xx3rNgqZOm2",
            email: "test@test.com",
            fullname: "Test",
            profileImage: "",
            createdAt: Date()
        )
    }

    override func tearDownWithError() throws {
        User.instance.clearUser()
    }

    func testListenChats() async throws {
        viewModel.listenChats()
        
        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)

        XCTAssertGreaterThan(self.viewModel.chatList.count, 0, "An error occurred when chats listening")
    }

}
