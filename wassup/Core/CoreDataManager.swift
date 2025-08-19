//
//  CoreData.swift
//  wassup
//
//  Created by Furkan Abbasioğlu on 12.10.2024.
//

import UIKit
import CoreData
import Foundation

class CoreDataManager {
    public static let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    static func save(value: NSManagedObject){
        do {
            try context.save()
            print("Data saved successfuly")
        } catch let error as NSError {
            print("Save error: \(error), \(error.userInfo)")
        }
    }
}
