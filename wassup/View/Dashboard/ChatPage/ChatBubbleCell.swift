//
//  ChatBubbleCell.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 10.09.2024.
//

import UIKit

class ChatBubbleCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    let bubbleBackgroundView = UIView()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    
    var isIncoming: Bool = true {
        didSet {
            bubbleBackgroundView.backgroundColor = isIncoming ? UIColor(white: 0.9, alpha: 1) : .systemBlue
            messageLabel.textColor = isIncoming ? .black : .white
            timeLabel.textColor = isIncoming ? .black : .white
            
            if isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .clear
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.layer.shadowColor = CGColor(gray: 0.8, alpha: 1)
        bubbleBackgroundView.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: 1, cornerHeight: 1, transform: nil)
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        timeLabel.numberOfLines = 1
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = timeLabel.font.withSize(14)
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal) // İçeriğine göre genişlesin
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal) // Yazıların kırpılmasını önlemek için yüksek öncelik
        addSubview(timeLabel)
        
        let cellMaxWidth = UIScreen.main.bounds.width * 0.7
        let constraints = [
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: cellMaxWidth),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -10),
            
            timeLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
