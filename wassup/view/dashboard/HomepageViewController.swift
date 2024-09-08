//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class HomepageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let authViewModel = AuthViewModel()
    let homepageViewModel = HomepageViewModel()
    
    var chatList = [ChatMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Task {
            chatList = await homepageViewModel.getChats(uid: authViewModel.auth.currentUser!.uid)
            tableView.reloadData()
        }
        
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
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.chatName.text = chatList[indexPath.row].members.first(where: { uid in
            uid != authViewModel.auth.currentUser!.uid
        })
        cell.lastMessage.text = chatList[indexPath.row].lastMessage
        cell.lastMessageDateTime.text = customDateFormatter(chatList[indexPath.row].updatedAt.dateValue())
        
        cell.profileImageView.image = UIImage(named: "person.png")
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.cornerRadius = 58/2
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        return cell
    }
    
    func customDateFormatter(_ timestamp: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: timestamp, to: currentDate)
        
        if calendar.isDateInToday(timestamp) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: timestamp)
        }
        
        if calendar.isDateInYesterday(timestamp) {
            return "Yesterday"
        }
        
        if let days = components.day, days < 7 {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: timestamp)
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: timestamp)
    }
}

