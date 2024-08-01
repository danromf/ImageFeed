//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Даниил Романов on 30.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        
        imagesListViewController.configure(ImagesListPresenter())
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        profileViewController.configure(ProfilePresenter())
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

