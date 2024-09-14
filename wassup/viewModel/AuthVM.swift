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
    
    let auth = Auth.auth()
    
    private func userDocReference(_ uid: String) -> DocumentReference {
        return Firestore.firestore().collection("Users").document(uid)
    }
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password)
    }
    
    func register(email: String, fullname: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                Task {
                    await self.createUserDoc(uid: authResult!.user.uid, email: email, fullname: fullname)
                }
            }
        }
    }
    
    private func createUserDoc(uid: String, email: String, fullname: String) async {
        do {
            User.instance.setUser(uid: uid, email: email, fullname: fullname, profileImage: "", createdAt: Date())
            try await userDocReference(uid).setData(User.instance.toJson())
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
            User.instance.clearUser()
        }
    }
    
    func getUserDocAndSync(_ uid: String,  complation: @escaping () -> ()) {
        DispatchQueue.global().async {
            self.userDocReference(uid).getDocument { snapshot, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let snapshot = snapshot!.data() {
                    User.instance.fromJson(snapshot)
                    complation()
                }
                
            }
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
