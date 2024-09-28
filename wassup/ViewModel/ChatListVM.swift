//
//  HomepageViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import OSLog
import Combine
import Foundation
import FirebaseFirestore

class ChatListVM : ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "chatListVMLog")
    
    @Published var chatList = [Chat]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func listenChats() {
        listenChatMetadataList()
            .flatMap { chatMetadataList in
                Publishers.MergeMany(
                    chatMetadataList.map { chatMetadata in
                        
                        self.listenTalker(talkerId: self.getTalkerId(members: chatMetadata.members))
                            .map { (chatMetadata, $0) }
                    }
                )
            }
            .map({ (chatMetadata, talker) in
                Chat(metadata: chatMetadata, talker: talker)
            })
            .sink { error in
                print(error)
            } receiveValue: { chat in
                
                let index = self.chatList.firstIndex(where: { chatX in
                    print("\(chatX.metadata.docId) == \(chat.metadata.docId)")
                    return chatX.metadata.docId == chat.metadata.docId
                })
                
                DispatchQueue.main.async {
                    
                    if index == nil {
                        self.chatList.append(chat)
                    } else if index! >= 0 {
                        self.chatList[index!] = chat
                        self.chatList.sort { chat1, chat2 in
                            return chat1.metadata.updatedAt.dateValue() > chat2.metadata.updatedAt.dateValue()
                        }
                    }
                }
                
            }.store(in: &cancellables)
        
        
    }
    
    private func listenChatMetadataList() -> AnyPublisher<[ChatMetadata], Error>{
        let chatMetadataListPublisher = PassthroughSubject<[ChatMetadata], Error>()
        
        Firestore.firestore().collection("Chats").whereField("members", arrayContains: User.instance.uid!).order(by: "updatedAt", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                chatMetadataListPublisher.send(completion: .failure(error))
                return
            }
            
            if let snapshot = snapshot {
                let chatMetadataList = snapshot.documents
                    .map { ChatMetadata.fromJson(docId: $0.documentID, json: $0.data()) }
                chatMetadataListPublisher.send(chatMetadataList)
            }
        }
        
        return chatMetadataListPublisher.eraseToAnyPublisher()
    }
    
    private func listenTalker(talkerId: String) -> AnyPublisher<Talker, Error> {
        let talkerPublisher = PassthroughSubject<Talker, Error>()
        
        Firestore.firestore().collection("Users").document(talkerId).addSnapshotListener { snapshot, error in
            if let error = error {
                talkerPublisher.send(completion: .failure(error))
            } else if let document = snapshot, document.exists, let data = document.data() {
                let talker = Talker.fromJson(document.documentID, data)
                talkerPublisher.send(talker)
            }
        }
        return talkerPublisher.eraseToAnyPublisher()
    }
    
    private func getTalkerId(members: [String]) -> String {
        return members[0] != User.instance.uid! ? members[0] : members[1]
    }
  
    func deleteChat(chatId: String) {
        Firestore.firestore().collection("Chats").document(chatId).delete()
    }
}
