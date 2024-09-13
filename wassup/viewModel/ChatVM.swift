//
//  ChatVM.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 12.09.2024.
//

import Foundation
import FirebaseFirestore

class ChatVM {
    
    private let db = Firestore.firestore()
    
    func listenChatMessages(chatId: String, onData: @escaping ([ChatMessage]?) -> Void) {
        db.collection("Chats").document(chatId).collection("Messages").order(by: "createdAt").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error getting documents: \(error!)")
                return
            }
            
            onData(snapshot?.documents.map { snapshot in
                return ChatMessage.fromJson(docId: snapshot.documentID, json: snapshot.data())
            })
        }
    }
}
