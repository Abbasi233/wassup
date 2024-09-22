//
//  Talker.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 14.09.2024.
//

import Foundation

struct Talker: Equatable {
    let uid: String
    let fullname: String
    let profileImage: String?
    
    static func fromJson(_ uid: String, _ json: [String : Any]) -> Talker {
        return Talker(
            uid: uid,
            fullname: json["fullname"] as! String,
            profileImage: json["profileImage"] as? String
        )
    }
}
