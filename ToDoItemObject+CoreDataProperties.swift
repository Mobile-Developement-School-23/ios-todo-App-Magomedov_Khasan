//
//  ToDoItemObject+CoreDataProperties.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 15.07.2023.
//
//

import Foundation
import CoreData

@objc(ToDoItemObject)
public class ToDoItemObject: NSManagedObject {}

extension ToDoItemObject {

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var importance: String?
    @NSManaged public var isAccepted: Bool
    @NSManaged public var hexColor: String?
    @NSManaged public var deadLine: Double
    @NSManaged public var changeDate: Double
    @NSManaged public var creationDate: Double

}

extension ToDoItemObject : Identifiable {}
