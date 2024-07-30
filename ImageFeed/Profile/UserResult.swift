//
//  UserResult.swift
//  ImageFeed
//
//  Created by Даниил Романов on 27.07.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}
