//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit
import Combine
import os.log

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var chatListVM = ChatListVM()
    var cancellables = Set<AnyCancellable>()
    
    var selectedChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        chatListVM.$chatList
            .receive(on: DispatchQueue.main)
            .sink { chatList in
                if chatList.isEmpty {
                    self.tableView.isHidden = true
                    self.emptyListLabel.isHidden = false
                    return
                }
                
                self.tableView.isHidden = false
                self.emptyListLabel.isHidden = true
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        chatListVM.listenChats(uid: User.instance.uid!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func newChatButtonClicked(_ sender: Any) { }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return chatListVM.chatList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListItemCell", for: indexPath) as! ChatListItemCell
        
        let chat = chatListVM.chatList[indexPath.row]
        
        cell.chatName.text = chat.talker.fullname
        cell.lastMessage.text = chat.metadata.lastMessage
        cell.lastMessageDateTime.text = customDateFormatter(chat.metadata.updatedAt.dateValue())
        
        cell.profileImageView.image = UIImage(named: "person.png")
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.cornerRadius = 58/2
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        cell.onClick = {
            self.selectedChat = chat
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.performSegue(withIdentifier: "ChatPageSegue", sender: self)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatVC
        vc.chat = selectedChat!
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

