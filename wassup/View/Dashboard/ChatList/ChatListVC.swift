//
//  HomepageViewController.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit
import Combine
import Kingfisher

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    var chatListVM = ChatListVM()
    var cancellables = Set<AnyCancellable>()
    
    var selectedChat: Chat?
    
    @IBAction func newChatButtonClicked(_ sender: Any) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        
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
        
        chatListVM.listenChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChatPageVC
        vc.chat = selectedChat!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return chatListVM.chatList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListItemCell", for: indexPath) as! ChatListItemCell
        
        let chat = chatListVM.chatList[indexPath.row]
        
        cell.chatName.text = chat.talker.fullname
        
        cell.checkmarkImage.isHidden = !chat.isLastMessageOwner
        cell.checkmarkImage.tintColor = chat.metadata.isSeen ? UIColor.systemBlue : UIColor.lightGray
        
        cell.lastMessage.text = chat.metadata.lastMessage
        cell.lastMessage.font = chat.isSeen ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 13)
        cell.lastMessageDateTime.text = customDateFormatter(chat.metadata.updatedAt.dateValue())
        cell.lastMessageDateTime.textColor = chat.isSeen ? UIColor.darkGray : UIColor.systemBlue
        
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.layer.cornerRadius = 28
        cell.profileImageView.clipsToBounds = true
        
        if let profileImageUrl = URL(string: chat.talker.profileImage ?? "") {
            cell.profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(systemName: Constants.personImage))
        }
        
        cell.newMessageBadgeView.layer.cornerRadius = 10
        cell.newMessageBadgeView.clipsToBounds = true
        cell.newMessageBadgeView.isHidden = chat.isSeen
        
        cell.onClick = {
            self.selectedChat = chat
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.performSegue(withIdentifier: "ChatPageSegue", sender: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AlertUtil.confirm(
                on: self,
                title: "Delete Chat",
                message: "Are you sure you want to delete this chat?", 
                onConfirm: {
                    self.chatListVM.deleteChat(chatId: self.chatListVM.chatList[indexPath.row].metadata.docId)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                }
            )
        }
    }
    
    private func customDateFormatter(_ timestamp: Date) -> String {
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
        
        if let days = components.day, let month = components.month, days < 7, month < 1 {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: timestamp)
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: timestamp)
    }
}

