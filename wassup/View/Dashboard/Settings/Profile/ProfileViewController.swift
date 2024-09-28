//
//  ProfileViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 9.09.2024.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameView: UILabel!
    @IBOutlet weak var emailView: UILabel!
    
    let authVM = AuthVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfileInformations()
    }
    
    private func setupProfileInformations() {
        fullnameView.text = User.instance.fullname
        emailView.text = User.instance.email
        
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        if let profileImageUrl = URL(string: User.instance.profileImage ?? "") {
            profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(systemName: Constants.personImage))
        }
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        authVM.logout()
    }
    
}
