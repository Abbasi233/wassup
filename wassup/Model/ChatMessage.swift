//
//  ChatMessage.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 11.09.2024.
//

import Foundation
import FirebaseCore

enum MessageType: Int, Encodable {
    case text = 1
    case document = 2
}

struct ChatMessage : Encodable {
    
    let docId: String?
    let text: String
    let owner: String
    let type: MessageType
    let createdAt: Timestamp
    
    static func fromJson(docId: String?, json: [String: Any]) -> ChatMessage {
        let type = json["type"] as? Int
        return ChatMessage(
            docId: docId,
            text: json["text"] as! String,
            owner: json["owner"] as! String,
            type: MessageType(rawValue: type!) ?? .text,
            createdAt: json["createdAt"] as! Timestamp
        )
    }
}
