//
//  LoginViewModel.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 2.09.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthVM {
    
    func AuthVM() {}
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    func login(email: String, password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
        auth.signIn(withEmail: email, password: password)
    }
    
    func register(email: String, fullname: String, password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
            
        auth.createUser(withEmail: email, password: password) { authResult, error in
            print("AuthResult: \(String(describing: authResult))")
            print("Error: \(String(describing: error))")
            
            if authResult != nil {
                Task {
                    await self.createUserDoc(uid: authResult!.user.uid, email: email, fullname: fullname)
                }
            }
        }
    }
    
    private func createUserDoc(uid: String, email: String, fullname: String) async {
        do {
            try await db.collection("Users").document(uid)
                .setData(
                    User(
                        uid: uid,
                        email: email,
                        fullname: fullname,
                        profileImage: "",
                        createdAt: Date()
                    ).toJson()
                )
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
        } catch {
            print(error)
        }
    }
    
}
