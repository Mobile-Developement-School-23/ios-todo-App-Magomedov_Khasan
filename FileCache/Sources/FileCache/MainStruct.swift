//  MainStruct.swift
//  Homework_1
//  Created by Хасан Магомедов on 10.06.2023.

import UIKit

public struct ToDoItem {
    
    public let id: String
    public let text: String
    public let importance: Importance
    public let isAccepted: Bool
    public let deadLine: Date?
    public let creationDate: Date
    public let changeDate: Date
    public let hexColor: String?
    
    public enum Importance: String {
        case low
        case basic
        case important
    }
    
    public init(id: String = UUID().uuidString, text: String, importance: Importance, isAccepted: Bool, deadLine: Date?, creationDate: Date = Date(), changeDate: Date = Date(), hexColor: String? = nil) {
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
            "creationDate": creationDate.timeIntervalSince1970,
            "changeData": changeDate.timeIntervalSince1970
        ]
        
        if importance != Importance.basic {
            dictionary["importance"] = importance.rawValue
        }
        if deadLine != nil {
            dictionary["deadLine"] = deadLine?.timeIntervalSince1970
        }
        return dictionary
    }
    
    var fileCsv: String {
        var csv = "\(id),\(text),\(isAccepted),\(creationDate.timeIntervalSince1970)"
        if importance != Importance.basic {
            csv += ",\(importance.rawValue)"
        }
        
        csv += ",\(changeDate.timeIntervalSince1970)"
        
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
                  let creationDate = dictionary["creationDate"] as? TimeInterval,
                  let changeDate = dictionary["changeDate"] as? TimeInterval
                  else { return nil }
            
            let deadLine = (dictionary["deadLine"] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
            let importanceString = dictionary["importance"] as? String ?? ""
            let importance = Importance(rawValue: importanceString) ?? .basic
            
            return ToDoItem(
                id: id,
                text: text,
                importance: importance,
                isAccepted: isAccepted,
                deadLine: deadLine,
                creationDate: Date(timeIntervalSince1970: creationDate),
                changeDate: Date(timeIntervalSince1970: changeDate)
            )
        }
        return nil
    }
    
    static func parse(csv: String) -> ToDoItem? {
        let values = csv.components(separatedBy: ",")
        guard values.count == 7,
            let isAccepted = Bool(values[2]),
            let creationDate = TimeInterval(values[3]),
            let changeDate = TimeInterval(values[4])
        else {
            return nil
        }
        let importance = Importance(rawValue: values[6]) ?? .basic
        let deadLine = TimeInterval(values[5])
        
        return ToDoItem(id: values[0], text: values[1], importance: importance, isAccepted: isAccepted, deadLine: deadLine.flatMap{Date( timeIntervalSince1970: $0) }, creationDate: Date(timeIntervalSince1970: creationDate), changeDate: Date(timeIntervalSince1970: changeDate))
    }
}

extension ToDoItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case isAccepted = "done"
        case deadline
        case creationDate = "created_at"
        case changeDate = "changed_at"
        case hexColor = "color"
        case lastUpdatedBy = "last_updated_by"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        importance = try Importance(rawValue: values.decode(String.self, forKey: .id)) ?? .basic
        isAccepted = try values.decode(Bool.self, forKey: .isAccepted)
        changeDate = try Date(
            timeIntervalSince1970: values.decode(Double.self, forKey: .changeDate)
        )
        
        creationDate = try Date(
            timeIntervalSince1970: values.decode(Double.self, forKey: .creationDate)
        )
        
        if let deadline = try values.decodeIfPresent(Double.self, forKey: .deadline) {
            deadLine = Date(timeIntervalSince1970: deadline)
        } else {
            deadLine = nil
        }
        
        hexColor = try values.decodeIfPresent(String.self, forKey: .hexColor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(
            UUID(uuidString: id), forKey: .id
        )
        try container.encode(text, forKey: .text)
        try container.encode(importance.rawValue, forKey: .importance)
        try container.encode(isAccepted, forKey: .isAccepted)
        try container.encode(Int(creationDate.timeIntervalSince1970), forKey: .creationDate)
        try container.encode(Int(changeDate.timeIntervalSince1970), forKey: .changeDate)
        
        if let deadline = deadLine {
            try container.encode(Int(deadline.timeIntervalSince1970), forKey: .deadline)
        }
        
        if let hexColor = hexColor {
            try container.encode(hexColor, forKey: .hexColor)
        }
        
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            try container.encode(deviceId, forKey: .lastUpdatedBy)
        } else {
            try container.encode("Test", forKey: .lastUpdatedBy)
        }
    }
}
