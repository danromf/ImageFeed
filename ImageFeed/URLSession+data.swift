//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Даниил Романов on 20.06.2024.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fullfilCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fullfilCompletionOnTheMainThread(.success(data))
                } else {
                    print("HTTP Error: Status Code \(statusCode)")
                    fullfilCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("URL Request Error: \(error.localizedDescription)")
                fullfilCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("URL Session Error: Unknown error")
                fullfilCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
}
