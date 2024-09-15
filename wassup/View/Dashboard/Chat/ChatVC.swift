//
//  ChatPageVC.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 10.09.2024.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let chatVM = ChatVM()
    
    var chat: Chat? // TODO: Dependency Injection ile non-optional hale getirilecek
    var chatMessages = [ChatMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "wallpaper")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        tableView.backgroundView = backgroundImage
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBarController?.tabBar.isHidden = true
        
        chatVM.listenChatMessages(chatId: chat!.metadata.docId) { data in
            guard let chatMessages = data else { return }
            self.chatMessages = chatMessages
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let message = messageTextField.text else { return }
        if message == "" { return }
        
        chatVM.chatMetadata = chat!.metadata
        chatVM.sendMessage(chatId: chat!.metadata.docId, message: message)
        messageTextField.text = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubbleCell", for: indexPath) as! ChatBubbleCell
        let chatMessage = chatMessages[indexPath.row]
        
        cell.isIncoming = chatMessage.owner != User.instance.uid!
        cell.messageLabel.text = chatMessage.text
        cell.timeLabel.text = getTime(dateTime: chatMessage.createdAt.dateValue())
        return cell
    }
    
    private func getTime(dateTime: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateTime)
    }
}
