//
//  ChatPageVC.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 10.09.2024.
//

import UIKit

class ChatPageVC: UIViewController {
    
    var chatMetadata: ChatMetadata = ChatMetadata.instance

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ChatMetadata: \(chatMetadata.lastMessage)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
