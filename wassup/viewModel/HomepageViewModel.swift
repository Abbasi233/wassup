//
//  HomepageViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import Foundation
import FirebaseFirestore

class HomepageViewModel {
    
    private let db = Firestore.firestore()
    
    func getChats(uid: String) async -> [ChatMetadata] {
        var chats: QuerySnapshot?
        
        do {
            chats  = try await db.collection("Chats").whereField("members", arrayContains: uid).getDocuments()
        } catch {
            print(error)
        }
        
        return chats!.documents.map { snapshot in
            return ChatMetadata.fromJson(docId: snapshot.documentID, json: snapshot.data())
        }
    }
    
}
