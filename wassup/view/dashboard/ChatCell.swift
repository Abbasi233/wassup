//
//  ChatCell.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 8.09.2024.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDateTime: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var onClick: () -> Void = {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { onClick() }
    }
    
}
