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
    
    var chatMetadata = ChatMetadata.instance
    
    private func chatReference(_ chatId: String) -> CollectionReference {
        return db.collection("Chats").document(chatId).collection("Messages")
    }
    
    func listenChatMessages(chatId: String, onData: @escaping ([ChatMessage]?) -> Void) {
        chatReference(chatId).order(by: "createdAt").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error getting documents: \(error!)")
                return
            }
            
            onData(snapshot?.documents.map { snapshot in
                return ChatMessage.fromJson(docId: snapshot.documentID, json: snapshot.data())
            })
        }
    }
    
    func sendMessage(chatId: String, message: String) {
        let chatMessage = ChatMessage(
            docId: nil,
            text: message,
            owner: "authVM.auth.currentUser!.uid",
            type: .text,
            createdAt: Timestamp(date: Date())
        )
        let result = try? chatReference(chatId).addDocument(from: message, encoder: Firestore.Encoder.init())
        print(result!)
    }
}
