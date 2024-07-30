//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Даниил Романов on 31.07.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private init() {}
    
    private func makeImagesListRequest(token: String, pageLimit: Int, pageNumber: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos")
            
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "\(pageLimit)")
        ]
            
        guard let url = urlComponents?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let _ = task {
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeImagesListRequest(token: token, pageLimit: 10, pageNumber: nextPage) else {
            DispatchQueue.main.async {
                print("[makeImagesListRequest] Network Error: Unsuccessful request making")
                completion(.failure(NetworkError.makeRequestError))
            }
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch (result) {
            case .success(let result):
                let photos = result.map { Photo(from: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    completion(.success(photos))
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": photos]
                    )
                }
                
            case .failure(let error):
                print("[ImagesListService] Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
