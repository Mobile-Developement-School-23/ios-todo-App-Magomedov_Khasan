//
//  StorageManager.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 14.07.2023.
//

import Foundation
import UIKit
import CoreData
import FileCache

final class StorageManger: NSObject {
    
    static let shared = StorageManger()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func saveItem(_ item: ToDoItem) {
        guard let itemDescription = NSEntityDescription.entity(forEntityName: "ToDoItemObject", in: context) else {
            return
        }
        
        let object = ToDoItemObject(entity: itemDescription, insertInto: context)
        object.id = item.id
        object.text = item.text
        object.importance = item.importance.rawValue
        object.deadLine = item.deadLine == nil ? 0 : item.deadLine!.timeIntervalSince1970
        object.isAccepted = item.isAccepted
        object.creationDate = item.creationDate.timeIntervalSince1970
        object.changeDate = item.changeDate.timeIntervalSince1970
        object.hexColor = item.hexColor
        
        appDelegate.saveContext()
    }
    
    func fetchItems() -> [ToDoItemObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemObject")
        
        return (try? context.fetch(fetchRequest) as? [ToDoItemObject]) ?? []
    }
    
    func fetchItem(with id: String) -> ToDoItemObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemObject")
        
        let items = try? context.fetch(fetchRequest) as? [ToDoItemObject]
        
        return items?.first(where: { $0.id == id })
    }
    
    func updateItem(id: String, item: ToDoItem) {
        guard let object = fetchItem(with: id) else { return }

        object.id = item.id
        object.text = item.text
        object.importance = item.importance.rawValue
        object.deadLine = item.deadLine == nil ? 0 : item.deadLine!.timeIntervalSince1970
        object.isAccepted = item.isAccepted
        object.creationDate = item.creationDate.timeIntervalSince1970
        object.changeDate = item.changeDate.timeIntervalSince1970
        object.hexColor = item.hexColor
        
        appDelegate.saveContext()
    }
    
    func deleteItem(withId id: String) {
        guard let object = fetchItem(with: id) else { return }
        
        context.delete(object)
        
        appDelegate.saveContext()
    }
    
    func deleteItems() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemObject")
        
        guard let objects = try? context.fetch(fetchRequest) as? [ToDoItemObject] else {
            return
        }
        
        for object in objects {
            context.delete(object)
        }
        
        appDelegate.saveContext()
    }
}
