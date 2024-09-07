//
//  user.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import Foundation

struct User: Equatable {
    let uid: String
    let email: String
    let profileImage: String
    let createdDate: Date
    
    func toJson() -> [String : Any] {
        return [
            "uid": uid,
            "email": email,
            "profileImage": profileImage,
            "createdDate": createdDate
        ]
    }

    func fromJson() -> User {
        return User(
            uid: uid,
            email: email,
            profileImage: profileImage,
            createdDate: createdDate
        )
    }
    
}
