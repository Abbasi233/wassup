//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class HomepageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let authViewModel = AuthViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newChatButtonClicked))
    }
    
    @objc func newChatButtonClicked(){}
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        do {
            try  authViewModel.logout()
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.profileImageView.image = UIImage(named: "person.png")
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.cornerRadius = 58/2
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        return cell
    }
    
}
