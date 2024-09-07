//
//  LoginViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 2.09.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel {
    
    func AuthViewModel() {}
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    func login(email: String, password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
        auth.signIn(withEmail: email, password: password)
    }
    
    func register(email: String, fullName: String, password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
            
        auth.createUser(withEmail: email, password: password) { authResult, error in
            print("AuthResult: \(authResult)")
            print("Error: \(error)")
            
            if authResult != nil {
                Task {
                    await self.createUserDoc(uid: authResult!.user.uid, email: email)
                }
            }
        }
    }
    
    private func createUserDoc(uid: String, email: String) async {
        do {
            try await db.collection("Users").document(uid)
                .setData(
                    User(
                        uid: uid,
                        email: email,
                        profileImage: "",
                        createdDate: Date()
                    ).toJson()
                )
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
}
