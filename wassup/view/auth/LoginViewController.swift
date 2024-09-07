//
//  ViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 1.09.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authViewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            authViewModel.login(email: email, password: password)
            return
        }
        
        print("Kullanıcı adı ve şifre boş gönderilemez.")
        present(AlertUtil.basic(title: "Login Failed", message: "You must enter email and password."), animated: true)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterVC", sender: nil)
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {}
    
}

