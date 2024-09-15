//
//  HomepageViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import Combine
import Foundation
import FirebaseFirestore

class ChatListVM : ObservableObject {
    
    @Published var chatList = [Chat]()
    
    let chatMetadataListPublisher = PassthroughSubject<[ChatMetadata], Error>()
    let talkerPublisher = PassthroughSubject<Talker, Error>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private func listenChatMetadataList(uid: String) {
        Firestore.firestore().collection("Chats").whereField("members", arrayContains: uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.chatMetadataListPublisher.send(completion: .failure(error))
                return
            }
            
            if let snapshot = snapshot {
                let chatMetadataList = snapshot.documents.map { ChatMetadata.fromJson(docId: $0.documentID, json: $0.data()) }
                self.chatMetadataListPublisher.send(chatMetadataList)
            }
        }
    }
    
    private func listenTalker(talkerId: String) {
        Firestore.firestore().collection("Users").document(talkerId).addSnapshotListener { snapshot, error in
            if let error = error {
                self.talkerPublisher.send(completion: .failure(error))
            } else if let document = snapshot, document.exists, let data = document.data() {
                let talker = Talker.fromJson(document.documentID, data)
                self.talkerPublisher.send(talker)
            }
        }
    }
    
    func listenChats(uid: String) {
        chatMetadataListPublisher
        //            .receive(on: DispatchQueue.main)
            .sink { error in
                print("ListenChats error: \(error)")
            } receiveValue: { chatMetadataList in
                chatMetadataList.forEach { chatMetadata in
                    let members = chatMetadata.members;
                    let talkerId = members[0] != uid ? members[0] : members[1]
                    
                    let chatMetadataPublisher = CurrentValueSubject<ChatMetadata, Error>(chatMetadata)
                    
//                    self.talkerListener = self.talkerPublisher.sink(receiveCompletion: { error in
//                        print(error)
//                    }, receiveValue: { talker in
//                        print(talker)
//                    })
                    self.listenTalker(talkerId: talkerId)
                    
                    Publishers.CombineLatest(chatMetadataPublisher, self.talkerPublisher).sink { error in
                        print("CombineLatest error: \(error)")
                    } receiveValue: { chatMetadata, talker in
                        let chat = Chat(metadata: chatMetadata, talker: talker)
                        
                        DispatchQueue.main.async {
//                            if var result = self.chatList.first(where: { $0.metadata.docId == chat.metadata.docId}) {
//                                result = chat
//                                return
//                            }
                            
                            self.chatList.append(chat)
                        }
                    }.store(in: &self.cancellables)
                    
                }
            }.store(in: &cancellables)
        
        listenChatMetadataList(uid: uid)
        
    }
    
}
