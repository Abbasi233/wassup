//
//  ChatVM.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 12.09.2024.
//

import Foundation
import FirebaseFirestore

class ChatPageVM {
    
    private let db = Firestore.firestore()
    private let encoder = Firestore.Encoder.init()
    
    var chatMetadata = ChatMetadata.instance
    
    private func chatMetadataDocReference(_ chatId: String) -> DocumentReference {
        return db.collection("Chats").document(chatId)
    }
    
    private func chatColReference(_ chatId: String) -> CollectionReference {
        return chatMetadataDocReference(chatId).collection("Messages")
    }
    
    func listenChatMessages(chatId: String, onData: @escaping ([ChatMessage]?) -> Void) {
        chatColReference(chatId).order(by: "createdAt").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error getting documents: \(error!)")
                return
            }
            
            onData(snapshot?.documents.map { snapshot in
                return ChatMessage.fromJson(docId: snapshot.documentID, json: snapshot.data())
            })
        }
    }
    
    func sendMessage(chatMetadata: ChatMetadata, message: String) {
        let chatMetadata = ChatMetadata(
            docId: chatMetadata.docId,
            lastMessage: message,
            lastMessageOwner: User.instance.uid!,
            isSeen: false,
            members: chatMetadata.members,
            createdAt: chatMetadata.createdAt,
            updatedAt: Timestamp(date: Date())
        )
        
        let chatMessage = ChatMessage(
            docId: nil,
            text: message,
            owner: User.instance.uid!,
            type: .text,
            createdAt: Timestamp(date: Date())
        )
        do {
            try chatColReference(chatMetadata.docId).addDocument(from: chatMessage, encoder: encoder)
            try chatMetadataDocReference(chatMetadata.docId).setData(from: chatMetadata, encoder: encoder)
        } catch {
            print("Failed")
        }
    }
    
    func setMessageSeen(chatMetadata: ChatMetadata) {
        chatMetadataDocReference(chatMetadata.docId).updateData(["isSeen": true])
    }
}
