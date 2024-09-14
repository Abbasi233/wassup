//
//  ChatMetadata.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import Foundation
import FirebaseCore

struct ChatMetadata: Codable {
    
    let docId: String
    let lastMessage: String
    let lastMessageOwner: String
    let isSeen: Bool
    let members: [String]
    let createdAt: Timestamp
    let updatedAt: Timestamp
    
    static let instance: ChatMetadata = ChatMetadata._initializer()
    
    static private func _initializer() -> ChatMetadata {
        return ChatMetadata(
            docId: "",
            lastMessage: "",
            lastMessageOwner: "",
            isSeen: true,
            members: [],
            createdAt: Timestamp(),
            updatedAt: Timestamp()
        )
    }
    
    static func fromJson(docId: String, json: [String: Any]) -> ChatMetadata {
        return ChatMetadata(
            docId: docId,
            lastMessage: json["lastMessage"] as! String,
            lastMessageOwner: json["lastMessageOwner"] as! String,
            isSeen: json["isSeen"] as! Bool,
            members: json["members"] as! [String],
            createdAt: json["createdAt"] as! Timestamp,
            updatedAt: json["updatedAt"] as! Timestamp
        )
    }
    
}
