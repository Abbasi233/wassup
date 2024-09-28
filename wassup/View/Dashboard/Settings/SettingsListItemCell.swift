//
//  SettingsListItemCell.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 28.09.2024.
//

import UIKit

class SettingsListItemCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var onClick: () -> Void = {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { onClick() }
    }
}
