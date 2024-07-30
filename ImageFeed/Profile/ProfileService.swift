//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Даниил Романов on 16.07.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private init() {}
    
    private func makeProfileRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.resume()
        
        guard let request = makeProfileRequest(token) else {
            DispatchQueue.main.async {
                print("[ProfileService] Network Error: Unsuccessful request making")
                completion(.failure(NetworkError.makeRequestError))
            }
            
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(from: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[ProfileService] Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
