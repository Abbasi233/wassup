//
//  ChatPageVC.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 10.09.2024.
//

import UIKit
import Kingfisher

class ChatPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let chatVM = ChatPageVM()
    
    var chat: Chat? // TODO: Dependency Injection ile non-optional hale getirilecek
    var chatMessages = [ChatMessage]()
    var pageInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        chatVM.setMessageSeen(chatMetadata: chat!.metadata)
        
        setupNavigationBarTitleView(name: chat?.talker.fullname, imageUrl: chat?.talker.profileImage)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: Constants.wallpaper)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        tableView.backgroundView = backgroundImage
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBarController?.tabBar.isHidden = true
        
        chatVM.listenChatMessages(chatId: chat!.metadata.docId) { data in
            guard let chatMessages = data else { return }
            self.chatMessages = chatMessages
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: self.pageInitialized)
                if !self.pageInitialized {self.pageInitialized = true}
            }
        }
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        let rawMessage = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let message = rawMessage, message != "" else { return }
        
        chatVM.sendMessage(chatMetadata: chat!.metadata, message: message)
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
    
    private func setupNavigationBarTitleView(name: String?, imageUrl: String?) {
        
        let imageView = UIImageView(image: UIImage(named: Constants.personImage))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let profileImageUrl = URL(string: imageUrl ?? "") {
            imageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: Constants.personImage))
        }
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
        self.navigationItem.leftItemsSupplementBackButton = true
    }
}
