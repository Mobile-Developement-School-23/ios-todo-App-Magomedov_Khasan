//  MainStruct.swift
//  Homework_1
//  Created by Хасан Магомедов on 10.06.2023.

import Foundation

struct ToDoItem {
    
    let id: String
    let text: String
    let importance: Importance
    let isAccepted: Bool
    let deadLine: Date?
    let creationDate: Date
    let changeDate: Date?
    let hexColor: String?
    
    enum Importance: String {
        case unimportant
        case usual
        case important
    }
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, isAccepted: Bool, deadLine: Date?, creationDate: Date = Date(), changeDate: Date?, hexColor: String? = nil) {
           self.id = id
           self.text = text
           self.importance = importance
           self.isAccepted = isAccepted
           self.deadLine = deadLine
           self.creationDate = creationDate
           self.changeDate = changeDate
           self.hexColor = hexColor
       }
}

extension ToDoItem {
    
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "isAccepted": isAccepted,
            "creationDate": creationDate.timeIntervalSince1970
        ]
        
        if importance != Importance.usual {
            dictionary["importance"] = importance.rawValue
        }
        if deadLine != nil {
            dictionary["deadLine"] = deadLine?.timeIntervalSince1970
        }
        if changeDate != nil {
            dictionary["changeData"] = changeDate?.timeIntervalSince1970
        }
        return dictionary
    }
    
    var fileCsv: String {
        var csv = "\(id),\(text),\(isAccepted),\(creationDate.timeIntervalSince1970)"
        if importance != Importance.usual {
            csv += ",\(importance.rawValue)"
        }
        if let changeDate = changeDate {
            csv += ",\(changeDate.timeIntervalSince1970)"
        }
        if let deadLine = deadLine {
            csv += ",\(deadLine.timeIntervalSince1970)"
        }
        return csv
    }
    
    static func parse(json: Any) -> ToDoItem? {
        if let dataJson = try? JSONSerialization.data(withJSONObject: json),
           let dictionary = try? JSONSerialization.jsonObject(with: dataJson) as? [String: Any] {
            guard let id = dictionary["id"] as? String,
                  let text = dictionary["text"] as? String,
                  let isAccepted = dictionary["isAccepted"] as? Bool,
                  let creationDate = dictionary["creationDate"] as? TimeInterval
                  else { return nil }
            
            let deadLine = (dictionary["deadLine"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
            let importanceString = dictionary["importance"] as? String ?? ""
            let importance = Importance(rawValue: importanceString) ?? .usual
            let changeDate = (dictionary["changeDate"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
            
            return ToDoItem(
                id: id,
                text: text,
                importance: importance,
                isAccepted: isAccepted,
                deadLine: deadLine,
                creationDate: Date(timeIntervalSince1970: creationDate),
                changeDate: changeDate
            )
        }
        return nil
    }
    
    static func parse(csv: String) -> ToDoItem? {
        let values = csv.components(separatedBy: ",")
        guard values.count == 7,
            let isAccepted = Bool(values[2]),
            let creationDate = TimeInterval(values[3])
        else {
            return nil
        }
        let importance = Importance(rawValue: values[6]) ?? .usual
        let deadLine = TimeInterval(values[5])
        let changeDate = TimeInterval(values[4])
        
        return ToDoItem(id: values[0], text: values[1], importance: importance, isAccepted: isAccepted, deadLine: deadLine.flatMap{Date( timeIntervalSince1970: $0) }, creationDate: Date(timeIntervalSince1970: creationDate), changeDate: changeDate.flatMap{Date(timeIntervalSince1970: $0)})
    }
}
