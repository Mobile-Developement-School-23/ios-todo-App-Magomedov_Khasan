//
//  URLSession.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 07.07.2023.
//

import Foundation

//extension URLSession {
//    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
//        var dataTask: URLSessionDataTask?
//        let cancel = {
//            dataTask?.cancel()
//        }
//        return try await withTaskCancellationHandler(
//            handler: {
//                onCancel()
//            },
//            operation: {
//                try Task.checkCancellation()
//                return try await withCheckedThrowingContinuation { continuation in
//                    dataTask = self.dataTask(with: request) { data, response, error in
//                        guard let data = data, let response = response else {
//                            let error = error ?? URLError(.badServerResponse)
//                            return continuation.resume(throwing: error)
//                        }
//                        continuation.resume(returning: (data, response))
//                    }
//                    dataTask?.resume()
//                }
//            }
//        )
//    }
//}
