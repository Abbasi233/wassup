//
//  Extensions.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 28.09.2024.
//

import Foundation
import FirebaseFirestore

extension Timestamp {
    func dateValue(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self.dateValue())
    }
}
