//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class HomepageViewController: UIViewController {
    
    let authViewModel = AuthViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        do {
          try  authViewModel.logout()
        } catch {
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
