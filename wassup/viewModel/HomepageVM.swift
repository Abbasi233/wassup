//
//  HomepageViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import Foundation
import FirebaseFirestore

class HomepageVM {
    
    private let db = Firestore.firestore()
    
    func getChats(uid: String) async -> [ChatMetadata] {
        var snapshot: QuerySnapshot?
        
        do {
            snapshot  = try await db.collection("Chats").whereField("members", arrayContains: uid).getDocuments()
        } catch {
            print(error)
        }
        
        return snapshot!.documents.map { snapshot in
            return ChatMetadata.fromJson(docId: snapshot.documentID, json: snapshot.data())
        }
    }
    
    func getChats(uid: String,  complation: @escaping ([ChatMetadata]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            Task {
                let result =  await self.getChats(uid: uid)
                
                DispatchQueue.main.async {
                    complation(result)
                }
            }
        }
    }
    
    func listenChats(uid: String) {
        db.collection("Chats").whereField("members", arrayContains: uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            // Koleksiyondaki belgeleri döngüye alıyoruz
            for document in snapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
            
        }
    }
    
}
