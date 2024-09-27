//
//  ChatNavigationBar.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 24.09.2024.
//

import UIKit

class ChatNavigationBar: UIView {
    
    let talkerFullname: String
    let talkerProfileImage: String
    let test = "dfsk"
    
    init(talkerFullname: String, talkerProfileImage: String) {
        self.talkerFullname = talkerFullname
        self.talkerProfileImage = talkerProfileImage
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: Constants.personImage))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
//        if let profileImageUrl = URL(string: self.talkerProfileImage ?? "") {
//            imageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: Constants.personImage))
//        }
        
//        let nameLabel = UILabel()
//        nameLabel.text =
//        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
//        nameLabel.textColor = .black
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(imageView)
//        titleView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
//            imageView.centerXAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            
//            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
//            nameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
        ])
//        setupNavigationBarTitleView(name: talkerFullname, imageUrl: talkerProfileImage)
    }
    
    private func setupNavigationBarTitleView(name: String?, imageUrl: String?) {
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: Constants.personImage))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let profileImageUrl = URL(string: imageUrl ?? "") {
            imageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: Constants.personImage))
        }
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(imageView)
//        titleView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
//            imageView.centerXAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            
//            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
//            nameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
        ])
        
//        self.navigationItem.titleView = titleView
    }
}
