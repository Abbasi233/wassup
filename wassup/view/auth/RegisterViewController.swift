//
//  RegisterViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    private let authViewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty, 
              let fullName = fullNameTextField.text, !fullName.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordAgain = passwordAgainTextField.text, !passwordAgain.isEmpty
        else {
            print("Kullanıcı adı ve şifre boş gönderilemez.")
            present(AlertUtil.basic(title: "Register Failed", message: "You must provide all informations."), animated: true)
            return
        }
        
        if password != passwordAgain {
            present(AlertUtil.basic(title: "Register Failed", message: "Passwords are not equal."), animated: true)
            return
        }
        
        authViewModel.register(email: email, fullName: fullName, password: password)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
