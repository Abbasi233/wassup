//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let homepageViewModel = HomepageVM()
    
    var chatList = [ChatMetadata]()
    var selectedChat: ChatMetadata?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        homepageViewModel.getChats(uid: User.instance.uid!, complation: { chatList in
            self.chatList = chatList
            self.tableView.reloadData()
        })
        
        homepageViewModel.listenChats(uid: User.instance.uid!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func newChatButtonClicked(_ sender: Any) {
        print("newChat")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return chatList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListItemCell", for: indexPath) as! ChatListItemCell
        
        cell.chatName.text = chatList[indexPath.row].members.first(where: { $0 != User.instance.uid! })
        cell.lastMessage.text = chatList[indexPath.row].lastMessage
        cell.lastMessageDateTime.text = customDateFormatter(chatList[indexPath.row].updatedAt.dateValue())
        
        cell.profileImageView.image = UIImage(named: "person.png")
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.cornerRadius = 58/2
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        cell.onClick = {
            self.selectedChat = self.chatList[indexPath.row]
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.performSegue(withIdentifier: "ChatPageSegue", sender: self)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatVC
        vc.chatMetadata = selectedChat!
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

