//
//  SettingsVC.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 28.09.2024.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let settingsList = [
        SettingsListItem(icon: "person.fill", title: "Profile")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsListItemCell", for: indexPath) as! SettingsListItemCell
        cell.icon.image = UIImage(named: settingsList[indexPath.row].icon)
        cell.title.text = settingsList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { settingsList.count }

}
