//
//  NetworkService.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 07.07.2023.
//

import FileCache

protocol NetworkService {
    func addItem(item: ToDoItem, revision: Int32, completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func getItems(completion: @escaping (Result<(Int32, [ToDoItem]), Error>) -> Void)
    func getItem(id: String, completion: @escaping (Result<(Int32, ToDoItem?), Error>) -> Void)
    func changeItem(item: ToDoItem, completion: @escaping (Result<(Int32, ToDoItem), Error>) -> Void)
    func removeItem(id: String, completion: @escaping (Result<(Int32, ToDoItem), Error>) -> Void)
    //func patch(revision: Int32, items: [ToDoItem], completion: @escaping (Result<(Int32, [ToDoItem]), Error>) -> Void)
}
