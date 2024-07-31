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
    
    private func makeLikeRequest(token: String, currentLike: Bool, photoId: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if !currentLike {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.resume()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService] Error: No OAuth2 Token")
            
            return
        }
        
        guard let request = makeLikeRequest(token: token, currentLike: isLike, photoId: photoId) else {
            DispatchQueue.main.async {
                print("[ImagesListService] Network Error: Unsuccessful request making")
                completion(.failure(NetworkError.makeRequestError))
            }
            
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked
                        )
                        
                        self.photos[index] = newPhoto
                        
                        completion(.success(()))
                    }
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
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if let _ = task {
            return
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService] Error: No OAuth2 Token")
            
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeImagesListRequest(token: token, pageLimit: 10, pageNumber: nextPage) else {
            DispatchQueue.main.async {
                print("[makeImagesListRequest] Network Error: Unsuccessful request making")
            }
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let result):
                let photos = result.map { Photo(from: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                }
                
            case .failure(let error):
                print("[ImagesListService] Error: \(error.localizedDescription)")
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
