//
//  ProfilePresenterMock.swift
//  ImageFeedTests
//
//  Created by Даниил Романов on 01.08.2024.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func profileLogout() {
    }
    
    func updateAvatarURL() {
    }
    
    func updateProfile() {
    }
}
