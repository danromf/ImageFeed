//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Даниил Романов on 23.07.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var task: URLSessionTask?
    
    private(set) var avatarURL: String?
    
    private init() {}
    
    private func makeAvatarRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/users/\(username)") else {
            return nil
        }
                      
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.resume()
        
        guard let request = makeAvatarRequest(token: token, username: username) else {
            DispatchQueue.main.async {
                print("[ProfileImageService] Network Error: Unsuccessful request making")
                completion(.failure(NetworkError.makeRequestError))
            }
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch (result) {
            case .success(let userResult):
                let profileImageURL = userResult.profileImage.small
                self.avatarURL = profileImageURL
                
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                
            case .failure(let error):
                print("[ProfileImageService] Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
