//
//  Chat.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 14.09.2024.
//

import Foundation

struct Chat : Equatable {
    let metadata: ChatMetadata
    let talker: Talker
}

extension Chat {
    var isSeen: Bool {
        return metadata.isSeen || isLastMessageOwner
    }
    
    var isLastMessageOwner: Bool {
        return metadata.lastMessageOwner == User.instance.uid
    }
}
