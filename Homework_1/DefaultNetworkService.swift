//
//  DefaultNetworkService.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 07.07.2023.
//

import Foundation
import FileCache

final class DefaultNetworkService: NetworkService {
    
    private let baseUrlString = "https://beta.mrdekk.ru/todobackend"
    private let token = "aknow"
    
    func addItem(item: ToDoItem, revision: Int32, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        let urlString = baseUrlString + "/list"
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        urlRequest.httpMethod = "POST"
        
        let item = ItemResult(element: item)

        guard let data = try? JSONEncoder().encode(item) else { return }
        
        urlRequest.httpBody = data
        
        print(String(data: data, encoding: .utf8)!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data, let json = try? JSONDecoder().decode(ListResult.self, from: data) else { return }
            
            completion(
                .success(json.list)
            )
        }.resume()
    }
    
    func getItems(completion: @escaping (Result<(Int32, [ToDoItem]), Error>) -> Void) {
        let urlString = baseUrlString + "/list"
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(
                    .failure(error)
                )
                return
            }
            
            guard let data = data, let json = try? JSONDecoder().decode(ListResult.self, from: data) else {
                return
            }
            
            completion(
                .success((json.revision, json.list))
            )
        }.resume()
    }
    
    func getItem(id: String, completion: @escaping (Result<(Int32, ToDoItem?), Error>) -> Void) {
        let urlString = baseUrlString + "/list/\(id)"
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(
                    .failure(error)
                )
                return
            }
            
            guard let data = data, let json = try? JSONDecoder().decode(GetItemResult.self, from: data) else {
                return
            }
            
            completion(
                .success((json.revision, json.element))
            )
        }.resume()
    }
    
    func changeItem(item: ToDoItem, completion: @escaping (Result<(Int32, ToDoItem), Error>) -> Void) {
        let urlString = baseUrlString + "/list/\(item.id)"
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "PUT"
        
        let item = ItemResult(element: item)

        guard let data = try? JSONEncoder().encode(item) else { return }
        
        urlRequest.httpBody = data

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONDecoder().decode(GetItemResult.self, from: data),
                  let element = json.element
            else {
                return
            }
            
            completion(
                .success(
                    (json.revision, element)
                )
            )
        }.resume()
    }
    
    func removeItem(id: String, completion: @escaping (Result<(Int32, ToDoItem), Error>) -> Void) {
        let urlString = baseUrlString + "/list/\(id)"
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data,
                  let json = try? JSONDecoder().decode(GetItemResult.self, from: data),
                  let element = json.element
            else {
                return
            }
            
            completion(
                .success(
                    (json.revision, element)
                )
            )
        }.resume()
    }
    
//    func patch(revision: Int32, items: [TodoItem], completion: @escaping ) {
//            let urlString = baseUrlString + "/list"
//
//            guard let url = URL(string: urlString) else { return }
//
//            var urlRequest = URLRequest(url: url)
//
//            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            urlRequest.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
//
//            urlRequest.httpMethod = "PATCH"
//
//            let items = PatchRequest(list: items)
//
//            guard let data = try? JSONEncoder().encode(items) else { return }
//
//            urlRequest.httpBody = data
//
//            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                
//                guard let data = data,
//                      let json = try? JSONDecoder().decode(ListResult.self, from: data)
//                else {
//                    return
//                }
//
//                completion(
//                    .success(
//                        (json.revision, json.list)
//                    )
//                )
//            }.resume()
//        }
}

struct ItemResult: Codable {
    let element: ToDoItem
}

struct ListResult: Codable {
    let status: String
    let list: [ToDoItem]
    let revision: Int32
}

struct GetItemResult: Codable {
    let status: String
    let element: ToDoItem?
    let revision: Int32
}
