//
//  ChatCell.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import UIKit

class ChatListItemCell: UITableViewCell {
    
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDateTime: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var newMessageBadgeView: UIView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    var onClick: () -> Void = {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { onClick() }
    }
    
}
