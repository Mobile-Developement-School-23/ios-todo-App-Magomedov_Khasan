//
//  FileCache.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 20.06.2023.
//

import Foundation

public final class FileCache {
    
    public private(set) var values: [String: ToDoItem] = [:]  //
    
    public init() {
        readingFile(fromFile: "force")
    }
    
    // Метод для добавления
    public func addValue(value: ToDoItem) {
        values[value.id] = value
        writeAllToFile(toFile: "force")
    }
    // Метод для удаления
    public func removeValue(idValue: String) {
        values[idValue] = nil
        writeAllToFile(toFile: "force")
    }
    // запись из файла
    func writeAllToFile(toFile: String) {
        let manager = FileManager.default
        guard let url = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
        ).first else { return } // путь к текущему расположению нашего приложения
        let jsons = values.values.map { $0.json } // из массива ToDoItem делаем массив из json-ов
        guard let data = try? JSONSerialization.data(withJSONObject: jsons)
        else {
            return
        } // из массива jsons делаем объект Data
        let newUrlForFile = url.appendingPathExtension("\(toFile).txt") // прописываем название файла, который нужно создать
        //print(newUrlForFile) печатаем получившийся url
        
        manager.createFile(atPath: newUrlForFile.path, contents: data) // создаем файл по пути \(atPath) и записываем в файл то, что получили \(contents)
    }
    // чтение из файла (практически все по аналогии записи из файла)
    func readingFile(fromFile: String) {
        let manager = FileManager.default
        guard let url = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
        ).first else { return }
        let newUrlForFile = url.appendingPathExtension("\(fromFile).txt")
        guard let data = try? Data(contentsOf: newUrlForFile), let jsons = try? JSONSerialization.jsonObject(with: data) as? [Any]
        else {
            return
        }
        
        for json in jsons {  // проходимся по каждому json-у в массиве (compactMap на основе json-ов создаст новый массив todoitem)
            if let item = ToDoItem.parse(json: json) { // если из json-а получили объект - верни item, если нет - верни nil
                values[item.id] = item
            }
        }
    }
    func saveToCsvFile(toCsvFile: String) {
        let manager = FileManager.default
        guard let url = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
        ).first else {
            return
        }
        let newUrlForFile = url.appendingPathComponent("\(toCsvFile).csv")
        let csvStr = values.values.map { $0.fileCsv }.joined(separator: "\n")
        do {
            try csvStr.write(
                to: newUrlForFile,
                atomically: true,
                encoding: .utf8
            )
        } catch {
            print("error with csv")
        }
    }
    func readFromCsvFile(fromCsv: String) {
        let manager = FileManager.default
        guard let url = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
        ).first else {
            return
        }
        let newFileForUrl = url.appendingPathExtension("\(fromCsv).csv")
        guard let strings = try? String(contentsOf: newFileForUrl).components(separatedBy: "\n") else {
            return
        }
        let todoItems = strings.compactMap { ToDoItem.parse(csv: $0) }
        
        values = todoItems.reduce(into: [:]) { result, item in
            result[item.id] = item
        }
    }
}

