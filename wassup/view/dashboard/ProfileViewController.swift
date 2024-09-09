//
//  ProfileViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 9.09.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    let authVM = AuthVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutButtonClicked(_ sender: Any) {
        authVM.logout()
    }
    
}
