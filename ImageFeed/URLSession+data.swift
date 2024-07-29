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
                    print("[URLSession: data] HTTP Error: Status Code \(statusCode)")
                    fullfilCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[URLSession: data] URL Request Error: \(error.localizedDescription)")
                fullfilCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[URLSession: data] URL Session Error: Unknown error")
                fullfilCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch (result) {
            case .success(let data):
                do {
                    let responseBody = try decoder.decode(T.self, from: data)
                    completion(.success(responseBody))
                } catch {
                    print("[URLSession: objectTask] Decoding Error: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[URLSession: objectTask] Network Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        return task
    }
}


