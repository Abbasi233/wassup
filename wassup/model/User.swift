//
//  user.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import Foundation

class User: Codable {
    
    static let instance = User()
    
    var uid: String?
    var email: String?
    var fullname: String?
    var profileImage: String?
    var createdAt: Date?
    
    private init() {}
    
    func setUser(uid: String, email: String, fullname: String, profileImage: String, createdAt: Date?) {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.profileImage = profileImage
        self.createdAt = createdAt
    }
    
    func clearUser() {
        self.uid = nil
        self.email = nil
        self.fullname = nil
        self.profileImage = nil
        self.createdAt = nil
    }
    
    func toJson() -> [String : Any] {
        return [
            "uid": uid!,
            "email": email!,
            "fullname": fullname!,
            "profileImage": profileImage!,
            "createdAt": createdAt!
        ]
    }
    
    func fromJson(_ json: [String : Any]) {
        self.uid = json["uid"] as? String
        self.email = json["email"] as? String
        self.fullname = json["fullname"] as? String
        self.profileImage = json["profileImage"] as? String
        self.createdAt = json["createdAt"] as? Date
    }
    
}
