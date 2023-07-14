//
//  FileCache.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 20.06.2023.
//

import Foundation
import UIKit
import FileCache

final class FileCache {

    private(set) var values: [String: ToDoItem] = [:]
    
    init() {
        for object in StorageManger.shared.fetchItems() {
            if let item = convert(from: object) {
                values[item.id] = item
            }
        }
    }

    func insert(item: ToDoItem) {
        values[item.id] = item

        StorageManger.shared.saveItem(item)
    }
    
    func update(id: String, withItem item: ToDoItem) {
        values[id] = item
        
        StorageManger.shared.updateItem(id: id, item: item)
    }

    func removeValue(itemId: String) {
        values[itemId] = nil
        
        StorageManger.shared.deleteItem(withId: itemId)
    }
}

extension FileCache {
    
    func convert(from object: ToDoItemObject) -> ToDoItem? {
        guard let id = object.id,
              let text = object.text,
              let importance = object.importance
        else {
            return nil
        }
        
        let isAccepted = object.isAccepted
        let deadLine = object.deadLine
        let creationDate = object.creationDate
        let dateOfChange = object.changeDate
        let hexColor = object.hexColor
        
        return ToDoItem(
            id: id,
            text: text,
            importance: ToDoItem.Importance(rawValue: importance) ?? .basic,
            isAccepted: isAccepted,
            deadLine: deadLine == 0 ? nil : Date(timeIntervalSince1970: deadLine),
            creationDate: Date(timeIntervalSince1970: creationDate),
            changeDate: Date(timeIntervalSince1970: dateOfChange),
            hexColor: hexColor
        )
    }
}
