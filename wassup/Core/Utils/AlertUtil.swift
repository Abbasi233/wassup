//
//  AlertUtil.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 7.09.2024.
//

import UIKit

class AlertUtil {
    
    static func basic(title: String, message: String) -> UIAlertController{
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
    static func confirm(on viewController: UIViewController, title: String, message: String, onConfirm: @escaping () -> Void) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) {value in
            onConfirm()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController.present(alert, animated: true)
    }
}
